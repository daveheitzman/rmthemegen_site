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

ActiveRecord::Schema.define(:version => 20110703003217) do

  create_table "newsfeeds", :force => true do |t|
    t.integer  "theme_id",   :default => 0
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.string   "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_histories_on_item_and_table_and_month_and_year"

  create_table "rmt_themes", :force => true do |t|
    t.string   "theme_name",       :default => "no_name_yet"
    t.text     "to_css"
    t.integer  "times_downloaded", :default => 0
    t.integer  "times_clicked",    :default => 0
    t.datetime "created_at"
    t.datetime "last_downloaded"
    t.datetime "last_clicked"
    t.integer  "rank",             :default => 100000
    t.datetime "updated_at"
    t.integer  "upvotes",          :default => 0
    t.integer  "downvotes",        :default => 0
    t.integer  "bg_color_style",   :default => 0
    t.text     "file_path"
    t.integer  "pop_score",        :default => 0
  end

  create_table "theme_comments", :force => true do |t|
    t.text     "comment"
    t.integer  "theme_id",           :default => 0
    t.integer  "number_of_likes",    :default => 0
    t.integer  "number_of_dislikes", :default => 0
    t.integer  "user_id",            :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
