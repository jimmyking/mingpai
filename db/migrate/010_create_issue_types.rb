class CreateIssueTypes < ActiveRecord::Migration
  def self.up
    create_table :issue_types do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :issue_types
  end
end
