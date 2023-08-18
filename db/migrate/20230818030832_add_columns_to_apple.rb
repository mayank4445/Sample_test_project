class AddColumnsToApple < ActiveRecord::Migration[7.0]
  def change
    add_reference :apples, :basket, null: false, foreign_key: true
    add_column :apples, :variety, :string
  end
end
