class CreateProductHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :product_histories do |t|
      t.string :name
      t.string :description
      t.string :category
      t.decimal :price
      t.string :serial_number
      t.date :warranty_expiry_date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
