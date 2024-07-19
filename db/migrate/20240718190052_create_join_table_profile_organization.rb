class CreateJoinTableProfileOrganization < ActiveRecord::Migration[7.1]
  def change
    create_join_table :profiles, :organizations do |t|
      t.index [:profile_id, :organization_id]
      # t.index [:organization_id, :profile_id]
    end
  end
end
