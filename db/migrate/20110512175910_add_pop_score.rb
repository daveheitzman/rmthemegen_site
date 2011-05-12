class AddPopScore < ActiveRecord::Migration
  def self.up
    add_column :rmt_themes, :pop_score, :integer, :default => 0
  end

  def self.down
  end
end
