class AddMethodAndConditionToWeightRecords < ActiveRecord::Migration[7.1]
  def change
    add_column :weight_records, :method, :string
    add_column :weight_records, :condition, :string
  end
end
