class AddMaskToRoles < ActiveRecord::Migration[6.1]
  def change
    add_column :spotlight_roles, :role_mask, :string
  end
end
