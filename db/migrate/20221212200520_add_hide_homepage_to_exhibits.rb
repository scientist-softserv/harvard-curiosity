class AddHideHomepageToExhibits < ActiveRecord::Migration[6.1]
  def change
    add_column :spotlight_exhibits, :hide_homepage, :boolean
  end
end
