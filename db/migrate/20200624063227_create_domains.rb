class CreateDomains < ActiveRecord::Migration[5.2]
  def change
    create_table :domains do |t|
      t.string :name
      t.datetime :reg_date
      t.datetime :exp_date
      t.integer :user_id

      t.timestamps
    end
  end
end
