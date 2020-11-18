class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.string :goal
      t.string :options, array: true

      t.timestamps
    end
  end
end
