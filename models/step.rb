class Step < ActiveRecord::Base
  belongs_to :type
  validates_presence_of     :name
end
