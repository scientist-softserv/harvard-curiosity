class AddSetNameToExhibits < ActiveRecord::Migration[6.1]
  def change
    add_column :spotlight_exhibits, :set_name, :string
  end
end
