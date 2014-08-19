class OrderProcess < ActiveRecord::Base

  belongs_to :operator, class_name: "Account", foreign_key: "operator_id"

end
