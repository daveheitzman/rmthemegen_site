class CreateRmtThemes < ActiveRecord::Migration
  def self.up
    create_table :rmt_themes do |t|
      t.string :theme_name, :default=>"no_name_yet"
      t.text :to_css
      t.integer :times_downloaded, :default =>0
      t.integer :times_clicked, :default =>0
      t.datetime :created_at, :default => Time.now
      t.datetime :last_downloaded, :default => nil
      t.datetime :last_clicked, :default => nil
      t.integer :rank, :default=>100000
      t.timestamps
    end
  end

  def self.down
    drop_table :rmt_themes
  end
end
