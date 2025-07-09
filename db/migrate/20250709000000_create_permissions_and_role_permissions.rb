class CreatePermissionsAndRolePermissions < ActiveRecord::Migration[7.1]
  def change
    create_table :permissions do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :description
      t.timestamps
    end

    create_table :role_permissions do |t|
      t.references :role, null: false, foreign_key: true
      t.references :permission, null: false, foreign_key: true
      t.timestamps
    end

    add_index :role_permissions, [:role_id, :permission_id], unique: true
  end
end 