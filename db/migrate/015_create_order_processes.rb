class CreateOrderProcesses < ActiveRecord::Migration
  def self.up
    create_table :order_processes do |t|
      t.integer :order_id
      t.integer :operator_id
      t.string :remark
      t.timestamps
    end
  end

  def self.down
    drop_table :order_processes
  end
end
