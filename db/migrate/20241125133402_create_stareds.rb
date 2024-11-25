class CreateStareds < ActiveRecord::Migration[7.2]
  def change
    create_table :stareds do |t|
      t.references :user, null: false, foreign_key: true
      t.references :message, null: false, foreign_key: true

      t.timestamps
    end
  end
end
