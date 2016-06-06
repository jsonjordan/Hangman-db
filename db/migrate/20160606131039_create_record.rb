class CreateRecord < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :user_id
      t.string :wins
      t.string :losses
    end
  end
end
