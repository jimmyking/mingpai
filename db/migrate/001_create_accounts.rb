class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :name
      t.string :surname
      t.string :email
      t.string :crypted_password
      t.string :role
      t.integer :role_id
      t.integer :is_edit
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
