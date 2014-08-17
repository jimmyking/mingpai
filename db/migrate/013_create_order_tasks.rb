class CreateOrderTasks < ActiveRecord::Migration
  def self.up
    create_table :order_tasks do |t|
      t.integer :group_id
      t.integer :order_id
      t.integer :step_id
      t.integer :oper_id
      t.timestamps
    end
  end

  def self.down
    drop_table :order_tasks
  end
end
