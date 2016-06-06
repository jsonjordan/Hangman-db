class SavedGame < ActiveRecord::Base
  validates_presence_of :user_id
  validates_presence_of :board
  validates_presence_of :attempts
end
