class Order < ActiveRecord::Base
  belongs_to :type
  belongs_to :step, foreign_key: "order_process_id"
  belongs_to :department


  before_save :init_orderno

  private
    def init_orderno
    	now_date = Time.new.strftime("%Y%m%d")
    	today_order_size = Order.count+1
    	self.order_no = "#{now_date}%04d" %today_order_size
    end
end
