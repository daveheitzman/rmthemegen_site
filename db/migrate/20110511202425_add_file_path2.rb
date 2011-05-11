class AddFilePath2 < ActiveRecord::Migration
  def self.up
    add_column :rmt_themes, :file_path, :string, :default=>'/tmp'
  end

  def self.down
  end
end
