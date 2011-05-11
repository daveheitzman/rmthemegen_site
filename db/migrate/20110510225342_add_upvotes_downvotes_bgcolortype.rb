class AddUpvotesDownvotesBgcolortype < ActiveRecord::Migration
  def self.up
    add_column :rmt_themes,:upvotes, :integer
    add_column :rmt_themes,:downvotes, :integer
    add_column :rmt_themes,:bg_color_style, :integer, :default=>0
  end

  def self.down
  end
end
