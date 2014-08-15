class OrderGroup < ActiveRecord::Base
  belongs_to :department
  belongs_to :type
  has_many :orders
  belongs_to :status

  before_create :init_groupno
  
  def progress
    @progress
  end
  
  def progress=value
    @progress = value
  end
  
  private
    def init_groupno
      new_no = OrderGroup.where("name = ? and department_id = ? and type_id = ?",self.name,self.department_id,self.type_id).count()+1
      self.no = new_no
      self.status = Status.find(3)
    end
end
