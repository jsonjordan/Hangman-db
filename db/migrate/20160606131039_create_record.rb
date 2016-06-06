class CreateRecord < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :user_id
      t.integer :wins, default: 0
      t.integer :losses, default: 0
    end
  end
end
