class AddFieldReport < ActiveRecord::Migration[5.1]
  def change
  	add_column :robots, :report, :string
  end
end
