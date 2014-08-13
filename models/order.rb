class Order < ActiveRecord::Base
  belongs_to :type
  belongs_to :step, foreign_key: "order_process_id"
  belongs_to :department
  belongs_to :status, foreign_key: "order_status_id"


  before_create :init_orderno
  
  def self.new_orders
    where("order_status_id = ?",1)
  end

  private
    def init_orderno
    	now_date = Time.new.strftime("%Y%m%d")
    	today_order_size = Order.count+1
    	self.order_no = "#{now_date}%04d" %today_order_size
      
      self.status = Status.first
    end
end
