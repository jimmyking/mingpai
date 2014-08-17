class OrderTask < ActiveRecord::Base
  belongs_to :group, :class => "OrderGroup", :foreign_key => "group_id"
  belongs_to :step
  belongs_to :oper, :class => "Account", :foreign_key => "oper_id"
  belongs_to :order
end
