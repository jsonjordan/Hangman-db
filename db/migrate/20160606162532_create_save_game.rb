class CreateSaveGame < ActiveRecord::Migration
  def change
    create_table :saved_games do |t|
      t.string :user_id
      t.string :board
      t.integer :attempts
      t.boolean :in_progress?
    end
  end
end
