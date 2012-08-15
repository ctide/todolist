class AddDatastructure < ActiveRecord::Migration
  def change
    create_table :entries do |e|
      e.string :task, :null => false
      e.timestamps
      e.integer :user_id, :null => false
      e.datetime :due_date
      e.boolean :completed, :default => false
      e.string :priority
    end
  end
end
