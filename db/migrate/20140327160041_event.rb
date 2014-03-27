class Event < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.column :name, :string
      t.column :description, :text
      t.column :location, :string
      t.column :start_time, :datetime
      t.column :end_time, :datetime

      t.timestamp
    end
  end
end
