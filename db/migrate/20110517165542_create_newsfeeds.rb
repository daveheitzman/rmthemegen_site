class CreateNewsfeeds < ActiveRecord::Migration
  def self.up
    create_table :newsfeeds do |t|
      t.integer :theme_id, :default => 0
      t.text :message,:default =>""
      t.timestamps
    end
  end

  def self.down
    drop_table :newsfeeds
  end
end
