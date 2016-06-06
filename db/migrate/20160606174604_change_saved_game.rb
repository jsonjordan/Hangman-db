class ChangeSavedGame < ActiveRecord::Migration
  def change
    # change_table :saved_games do |t|
    #   t.string :word
    # end
    add_column :saved_games, :word, :string
  end
end
