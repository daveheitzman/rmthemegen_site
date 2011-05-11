class FullFilePath4 < ActiveRecord::Migration
  def self.up
    add_column :rmt_themes, :file_path, :text

  end

  def self.down
  end
end
