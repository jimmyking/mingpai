class CreateSteps < ActiveRecord::Migration
  def self.up
    create_table :steps do |t|
      t.string :name
      t.integer :level
      t.integer :type_id
      t.timestamps
    end
  end

  def self.down
    drop_table :steps
  end
end
