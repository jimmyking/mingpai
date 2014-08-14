class CreateOrderGroups < ActiveRecord::Migration
  def self.up
    create_table :order_groups do |t|
      t.date :name
      t.integer :department_id
      t.integer :step_id
      t.integer :no
      t.timestamps
    end
  end

  def self.down
    drop_table :order_groups
  end
end
