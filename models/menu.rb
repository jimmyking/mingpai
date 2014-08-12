class Menu < ActiveRecord::Base
  belongs_to :parent, class_name: "Menu"
  has_many :children, class_name: "Menu", foreign_key: "parent_id"
  
  
  def self.sub_scope
    where("parent_id IS NOT NULL")
  end
end
