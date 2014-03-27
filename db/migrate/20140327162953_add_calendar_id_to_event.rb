class AddCalendarIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :calender_id, :integer
  end
end
