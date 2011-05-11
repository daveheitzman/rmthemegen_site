class FullFilePath2 < ActiveRecord::Migration
  def self.up
    remove_column :rmt_themes, :file_path

  end

  def self.down
  end
end
