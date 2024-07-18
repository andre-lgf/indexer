class CreateOrganizations < ActiveRecord::Migration[7.1]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :organization_url, null: false
      t.string :image_url, null: false

      t.timestamps
    end
    add_index :organizations, :name, unique: true
    add_index :organizations, :organization_url, unique: true
    add_index :organizations, %i[name organization_url], unique: true
  end
end
