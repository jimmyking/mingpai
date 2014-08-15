class OrderGroup < ActiveRecord::Base

  before_create :init_groupno
  
  
  private
    def init_groupno
      new_no = OrderGroup.where("name = ? and department_id = ? and type_id = ?",self.name,self.department_id,self.type_id).count()+1
      self.no = new_no
    end
end
