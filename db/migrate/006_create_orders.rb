class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :order_no   #订单号
      t.integer :type_id   #需求类别
      t.integer :order_status_id #状态
      t.integer :order_process_id #进度
      t.integer :department_id #服务器
      t.string :acter  #角色
      t.string :level  #当前等级
      t.string :demand  #需求
      t.string :acter_account   #帐号
      t.string :acter_pw   #密码
      t.string :wangwang  #旺旺
      t.string :mobile  #电话
      t.string :qq
      t.string :amount  #订单金额
      t.string :paytype #支付方式
      t.integer :issue_type_id
      t.string :issue_memo
      t.string :memo  #备注
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
