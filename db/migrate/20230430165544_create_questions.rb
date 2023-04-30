class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.string :question
      t.string :answer
      t.integer :ask_count
      t.string :context

      t.timestamps
    end
  end
end
