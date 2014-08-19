class Order < ActiveRecord::Base
  belongs_to :type
  belongs_to :department
  belongs_to :status, foreign_key: "order_status_id"
  belongs_to :issue_type
  belongs_to :order_group
  has_many :processes, class_name: "OrderProcess", foreign_key: "order_id"


  before_create :init_orderno
  
  def self.new_orders
    where("order_status_id = ? and issue_type_id IS NULL",1)
  end

  def self.audited
    where("order_status_id = ? and issue_type_id IS NULL",2)
  end

  private
    def init_orderno
    	now_date = Time.new.strftime("%Y%m%d")
    	today_order_size = Order.count+1
    	self.order_no = "#{now_date}%04d" %today_order_size
       self.now_level = self.start_level
       self.status = Status.first
    end
end
