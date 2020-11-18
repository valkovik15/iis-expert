# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Question.create(goal: "city", options: ["Grodno", "Mahileu", "Minsk"])
Question.create(goal: "won medals after 2015", options: ["Yes", "No"])
Question.create(goal: "total medals > 10", options: ["Yes", "No"])
Question.create(goal: "won medals after 2012", options: ["Yes", "No"])
Question.create(goal: "times CHGK won", options: ["0", "1", "2"])
Question.create(goal: "won EQ", options: ["Yes", "No"])
Question.create(goal: "gender", options: ["F", "M"])
Question.create(goal: "jeopardy medals", options: ["0", "1", "2"])
