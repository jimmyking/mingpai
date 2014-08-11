class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name
      t.timestamps
    end
    
    create_table :menus_roles, id: false do |t|
      t.belongs_to :role
      t.belongs_to :menu
    end
  end

  def self.down
    drop_table :roles
  end
end
