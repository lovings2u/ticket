class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :concert_name,         null: false
      t.string :site_url,             null: false
      t.datetime :open_date
      t.text :detail_info,            null: false
      t.string :image_url
      t.integer :source_site        #1:인터파크, 2:멜론티켓, 3:옥션티켓, 4:yes24티켓
      t.string :tc_key,               null: false, unique: true

      t.timestamps
    end
  end
end
