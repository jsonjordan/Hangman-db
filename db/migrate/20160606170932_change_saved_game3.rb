class ChangeSavedGame3 < ActiveRecord::Migration
  def change
    change_table :saved_games do |t|
      t.rename :in_progress?, :in_progress
    end
  end
end
