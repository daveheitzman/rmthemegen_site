class CreateThemeComments < ActiveRecord::Migration
  def self.up
    create_table :theme_comments do |t|
      t.text :comment
      t.integer :theme_id, :default => 0
      #for now the likes/dislikes are for liking the comments themselves, not the theme. That could be confusing. 
      t.integer :number_of_likes, :default => 0
      t.integer :number_of_dislikes, :default => 0
      t.integer :user_id, :default=>0
      t.timestamps
    end
  end

  def self.down
    drop_table :theme_comments
  end
end
