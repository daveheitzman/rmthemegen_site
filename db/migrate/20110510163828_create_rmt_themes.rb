class CreateRmtThemes < ActiveRecord::Migration
  def self.up
    create_table :rmt_themes do |t|
      t.string :theme_name
      t.text :to_css
      t.integer :times_downloaded
      t.integer :times_clicked
      t.datetime :created_at
      t.datetime :last_downloaded
      t.datetime :last_clicked
      t.integer :rank, :default=>100000
      t.timestamps
    end
  end

  def self.down
    drop_table :rmt_themes
  end
end
