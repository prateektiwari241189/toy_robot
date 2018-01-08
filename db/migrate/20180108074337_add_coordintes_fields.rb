class AddCoordintesFields < ActiveRecord::Migration[5.1]
  def change
  	add_column :robots, :x, :string
  	add_column :robots, :y, :string
  	add_column :robots, :f, :string
  	add_column :robots, :max_x, :string
  	add_column :robots, :max_y, :string
  end
end
