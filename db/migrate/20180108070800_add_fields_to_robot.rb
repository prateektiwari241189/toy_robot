class AddFieldsToRobot < ActiveRecord::Migration[5.1]
  def change
  	add_column :robots, :size_grid, :string
  	add_column :robots, :commands, :string
  	
  end
end
