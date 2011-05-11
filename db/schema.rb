# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110511202425) do

  create_table "rmt_themes", :force => true do |t|
    t.string   "theme_name"
    t.text     "to_css"
    t.integer  "times_downloaded"
    t.integer  "times_clicked"
    t.datetime "created_at"
    t.datetime "last_downloaded"
    t.datetime "last_clicked"
    t.integer  "rank",             :default => 100000
    t.datetime "updated_at"
    t.integer  "upvotes"
    t.integer  "downvotes"
    t.integer  "bg_color_style",   :default => 0
    t.string   "file_path",        :default => "/tmp"
  end

end
