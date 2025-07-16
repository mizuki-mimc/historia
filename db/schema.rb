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

ActiveRecord::Schema[7.2].define(version: 2025_07_16_054830) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "character_feature_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "character_features", force: :cascade do |t|
    t.string "explanation"
    t.bigint "character_id", null: false
    t.bigint "character_feature_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.index ["character_feature_category_id"], name: "index_character_features_on_character_feature_category_id"
    t.index ["character_id"], name: "index_character_features_on_character_id"
  end

  create_table "character_relationships", force: :cascade do |t|
    t.string "relationship_type"
    t.bigint "character_id", null: false
    t.bigint "related_character_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.index ["character_id"], name: "index_character_relationships_on_character_id"
    t.index ["related_character_id"], name: "index_character_relationships_on_related_character_id"
  end

  create_table "characters", force: :cascade do |t|
    t.string "name"
    t.string "race"
    t.integer "gender"
    t.string "age"
    t.string "category"
    t.bigint "story_id", null: false
    t.bigint "birthplace_world_guide_id"
    t.bigint "address_world_guide_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_world_guide_id"], name: "index_characters_on_address_world_guide_id"
    t.index ["birthplace_world_guide_id"], name: "index_characters_on_birthplace_world_guide_id"
    t.index ["story_id"], name: "index_characters_on_story_id"
  end

  create_table "flags", force: :cascade do |t|
    t.bigint "story_id", null: false
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["story_id"], name: "index_flags_on_story_id"
  end

  create_table "plot_characters", force: :cascade do |t|
    t.bigint "plot_id", null: false
    t.bigint "character_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_plot_characters_on_character_id"
    t.index ["plot_id", "character_id"], name: "index_plot_characters_on_plot_id_and_character_id", unique: true
    t.index ["plot_id"], name: "index_plot_characters_on_plot_id"
  end

  create_table "plot_flags", force: :cascade do |t|
    t.bigint "plot_id", null: false
    t.bigint "flag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "check_created", default: false, null: false
    t.boolean "check_recovered", default: false, null: false
    t.index ["flag_id"], name: "index_plot_flags_on_flag_id"
    t.index ["plot_id", "flag_id"], name: "index_plot_flags_on_plot_id_and_flag_id", unique: true
    t.index ["plot_id"], name: "index_plot_flags_on_plot_id"
  end

  create_table "plot_world_guides", force: :cascade do |t|
    t.bigint "plot_id", null: false
    t.bigint "world_guide_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plot_id"], name: "index_plot_world_guides_on_plot_id"
    t.index ["world_guide_id"], name: "index_plot_world_guides_on_world_guide_id"
  end

  create_table "plots", force: :cascade do |t|
    t.string "chapter"
    t.string "title"
    t.string "summary"
    t.text "content"
    t.integer "order"
    t.bigint "story_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["story_id"], name: "index_plots_on_story_id"
  end

  create_table "stories", force: :cascade do |t|
    t.string "title"
    t.string "genre"
    t.text "thema"
    t.text "synopsis"
    t.integer "status", default: 0
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_stories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
  end

  create_table "world_feature_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "world_guide_features", force: :cascade do |t|
    t.string "explanation"
    t.bigint "world_guide_id", null: false
    t.bigint "world_feature_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.index ["world_feature_category_id"], name: "index_world_guide_features_on_world_feature_category_id"
    t.index ["world_guide_id"], name: "index_world_guide_features_on_world_guide_id"
  end

  create_table "world_guides", force: :cascade do |t|
    t.string "category"
    t.string "world_name"
    t.string "country_name"
    t.string "region_name"
    t.bigint "story_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["story_id"], name: "index_world_guides_on_story_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "character_features", "character_feature_categories"
  add_foreign_key "character_features", "characters"
  add_foreign_key "character_relationships", "characters"
  add_foreign_key "character_relationships", "characters", column: "related_character_id"
  add_foreign_key "characters", "stories"
  add_foreign_key "characters", "world_guides", column: "address_world_guide_id"
  add_foreign_key "characters", "world_guides", column: "birthplace_world_guide_id"
  add_foreign_key "flags", "stories"
  add_foreign_key "plot_characters", "characters"
  add_foreign_key "plot_characters", "plots"
  add_foreign_key "plot_flags", "flags"
  add_foreign_key "plot_flags", "plots"
  add_foreign_key "plot_world_guides", "plots"
  add_foreign_key "plot_world_guides", "world_guides"
  add_foreign_key "plots", "stories"
  add_foreign_key "stories", "users"
  add_foreign_key "world_guide_features", "world_feature_categories"
  add_foreign_key "world_guide_features", "world_guides"
  add_foreign_key "world_guides", "stories"
end
