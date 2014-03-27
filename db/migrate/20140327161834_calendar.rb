class Calendar < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.column :name, :string

      t.timestamp
    end
  end
end
