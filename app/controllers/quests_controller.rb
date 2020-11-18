class QuestsController < ApplicationController
    before_action :get_quest, only: [:show, :update]
  def create
    @quest = Quest.create(goals_stack: ['player'], context_stack: [], rejected_rules: [])
    redirect_to quest_path(@quest) if @quest
  end

  def show
    @rules = rules
    analyze_rules(@quest)
    @question = get_question_target(@quest)
  end

  def update
    @quest.update!(context_stack: @quest.context_stack+[{params['attr'] => params['value']}], goals_stack: @quest.goals_stack-[params['attr']])
    analyze_rules(@quest)
    @question = get_question_target(@quest)
    info = {is_solved: @quest.goals_stack.empty?, probable_answer: @quest.context_stack.inject(Hash.new) do |product, el| 
        product.merge(eval(el))
        end.fetch('player', 'Do not know')}
    render json: info.merge(@question&.as_json || {})
  end

  private

  def analyze_rules(quest)
    
    loop do
      new_solved_rules = []
      new_context_stack = []
      rules.each_with_index do |rule, index|
      if quest.rejected_rules.include?(index.to_s)
        next
      else
        if (rule['if'].pluck('attr') - quest.context_stack.inject(Hash.new) do |product, el| 
            product.merge(eval(el))
            end.keys).empty?
          if (rule['if'].to_a.pluck('attr', 'value') - ( quest.context_stack.inject(Hash.new) do |product, el| 
            product.merge(eval(el))
            end).to_a).empty?
            new_context_stack << {rule['then']['attr'] => rule['then']['value']}
            quest.goals_stack.delete(rule['then']['attr'])
          end
          new_solved_rules << index.to_i
        end
        
      end

        quest.save!
        quest.update(context_stack: (quest.context_stack + new_context_stack).uniq, rejected_rules: (quest.rejected_rules.uniq + new_solved_rules).uniq)
        quest.reload
    end
      break if new_context_stack.empty? || quest.goals_stack.empty?
    end
        
  end

  def get_question_target(quest)
    question = Question.find_by(goal: quest.goals_stack.last)
    return question if question
    new_goal = nil
    rules.each_with_index do |rule, index|
        if quest.rejected_rules.include?(index)
          next
        end
        if rule['then']['attr'] == quest.goals_stack.last
            q = Question.where(goal: rule['if'].pluck('attr') - quest.context_stack.inject(Hash.new) do |product, el| 
                product.merge(eval(el))
                end.keys).first
            if q
                quest.update(goals_stack: (quest.goals_stack + [q.goal]).uniq)
                return q
            else
                new_goal ||= (rule['if'].pluck('attr') - quest.context_stack.inject(Hash.new) do |product, el| 
                    product.merge(eval(el))
                    end.keys).first
            end
        end
    end
    return nil if !new_goal
    quest.update!(goals_stack: (quest.goals_stack + [new_goal]))
    return get_question_target(quest)
  end

  def rules
    @@rules ||= JSON.parse(File.read('./rules.json'))
  end

  private

  def get_quest
    @quest = Quest.find(params[:id])
  end
end
