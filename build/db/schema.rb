# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

<<<<<<< HEAD
ActiveRecord::Schema[8.0].define(version: 2025_07_05_155309) do
=======
ActiveRecord::Schema[8.0].define(version: 2025_07_02_155834) do
>>>>>>> origin/cinemas
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tmdb_id", null: false
    t.string "title"
    t.string "poster_path"
    t.index ["user_id", "tmdb_id"], name: "index_bookmarks_on_user_id_and_tmdb_id", unique: true
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "cinema_favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "cinemasdef_id", null: false
<<<<<<< HEAD
=======
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cinemasdef_id"], name: "index_cinema_favorites_on_cinemasdef_id"
    t.index ["user_id"], name: "index_cinema_favorites_on_user_id"
  end

  create_table "cinema_programmings", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.string "movie_title"
    t.text "showtimes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cinema_showtimes", force: :cascade do |t|
    t.string "day"
    t.string "movie"
    t.string "show_type"
    t.text "show_times"
>>>>>>> origin/cinemas
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cinemasdef_id"], name: "index_cinema_favorites_on_cinemasdef_id"
    t.index ["user_id"], name: "index_cinema_favorites_on_user_id"
  end

  create_table "cinemas", force: :cascade do |t|
    t.string "name", null: false
    t.string "address", null: false
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_cinemas_on_name", unique: true
  end

  create_table "cinemasdef", id: :serial, force: :cascade do |t|
    t.integer "tamburino_id"
    t.string "name", limit: 255
    t.string "address", limit: 255
    t.string "town", limit: 100
    t.string "province", limit: 100
    t.string "phone", limit: 50
    t.float "lat"
    t.float "lon"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.bigint "post_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "movie_id"
    t.string "movie_title"
    t.string "movie_poster_path"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.date "birth_date"
    t.string "username"
    t.string "provider"
    t.string "uid"
    t.integer "tmdb_fav1"
    t.integer "tmdb_fav2"
    t.integer "tmdb_fav3"
    t.string "role", default: "user"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "cinema_favorites", "cinemasdef"
  add_foreign_key "cinema_favorites", "users"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "posts", "users"
end
