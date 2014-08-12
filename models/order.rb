class Order < ActiveRecord::Base
  belongs_to :type
  belongs_to :step, foreign_key: "order_process_id"
  belongs_to :department
end
