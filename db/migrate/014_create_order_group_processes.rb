class CreateOrderGroupProcesses < ActiveRecord::Migration
  def self.up
    create_table :order_group_processes do |t|
      t.integer :group_id
      t.integer :operator_id
      t.string :remark
      t.timestamps
    end
  end

  def self.down
    drop_table :order_group_processes
  end
end
