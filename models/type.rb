class Type < ActiveRecord::Base
	has_many :steps
  
  validates_presence_of     :name
end
