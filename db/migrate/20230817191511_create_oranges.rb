class CreateOranges < ActiveRecord::Migration[7.0]
  def change
    create_table :oranges do |t|

      t.timestamps
    end
  end
end
