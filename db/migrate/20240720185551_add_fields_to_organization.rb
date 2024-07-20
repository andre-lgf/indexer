class AddFieldsToOrganization < ActiveRecord::Migration[7.1]
  def change
    add_column :organizations, :gh_id, :bigint
    add_column :organizations, :num_public_repos, :integer
    add_column :organizations, :num_public_gists, :integer
    add_column :organizations, :followers, :integer
    add_column :organizations, :following, :integer
    add_column :organizations, :num_members, :integer
  end
end
