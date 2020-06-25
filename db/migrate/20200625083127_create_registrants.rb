class CreateRegistrants < ActiveRecord::Migration[5.2]
  def change
    create_table :registrants do |t|
      t.integer :user_id
      t.string :handle
      t.text :address
      t.string :contact_number

      t.timestamps
    end
  end
end
