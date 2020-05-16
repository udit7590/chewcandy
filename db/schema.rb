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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2016_01_23_085006) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "primary"
    t.bigint "user_id"
    t.string "country"
    t.string "state"
    t.string "city"
    t.integer "pincode"
    t.text "full_address"
    t.datetime "verified_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "blog_posts", force: :cascade do |t|
    t.integer "user_id"
    t.string "slug"
    t.string "title"
    t.boolean "published"
    t.datetime "published_at"
    t.string "markup_lang"
    t.text "raw_content"
    t.text "html_content"
    t.text "html_overview"
    t.string "video_url"
    t.string "meta_description"
    t.string "meta_image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.index ["published_at"], name: "index_blog_posts_on_published_at"
    t.index ["slug"], name: "index_blog_posts_on_slug", unique: true
    t.index ["user_id"], name: "index_blog_posts_on_user_id"
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.integer "assetable_id"
    t.string "assetable_type", limit: 30
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable"
    t.index ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "commentable_id"
    t.string "commentable_type"
    t.string "title"
    t.text "body"
    t.string "subject"
    t.integer "user_id", null: false
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "full_name"
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "criteria", force: :cascade do |t|
    t.string "actable_type"
    t.bigint "actable_id"
    t.string "name"
    t.boolean "one_time"
    t.datetime "valid_from"
    t.datetime "valid_till"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actable_type", "actable_id"], name: "index_criteria_on_actable_type_and_actable_id"
  end

  create_table "criteria_discounts", id: false, force: :cascade do |t|
    t.bigint "discount_id", null: false
    t.bigint "criterium_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discounts", force: :cascade do |t|
    t.bigint "user_id"
    t.string "email"
    t.string "code"
    t.decimal "amount"
    t.string "unit"
    t.decimal "max_amount"
    t.boolean "active"
    t.datetime "deleted_at"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_discounts_on_deleted_at"
    t.index ["user_id"], name: "index_discounts_on_user_id"
  end

  create_table "discounts_orders", id: false, force: :cascade do |t|
    t.bigint "discount_id", null: false
    t.bigint "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "enquiries", force: :cascade do |t|
    t.bigint "user_id"
    t.string "from_email"
    t.string "from_name"
    t.string "about"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_enquiries_on_user_id"
  end

  create_table "festival_criteria", force: :cascade do |t|
    t.string "name"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "min_order_criteria", force: :cascade do |t|
    t.decimal "amount"
    t.integer "quantity"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "shopping_cart_id"
    t.string "state"
    t.decimal "total_product_amount", precision: 12, scale: 2
    t.decimal "total_quantity", precision: 12, scale: 2
    t.decimal "total_tax_amount", precision: 12, scale: 2
    t.decimal "total_shipping_amount", precision: 12, scale: 2
    t.string "payment_method"
    t.boolean "verified", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "coupon_code"
    t.decimal "discount_amount", precision: 12, scale: 2
    t.string "number"
    t.decimal "total_packaging_amount", precision: 12, scale: 2
    t.index ["shopping_cart_id"], name: "index_orders_on_shopping_cart_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "type"
    t.decimal "price", precision: 12, scale: 2
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "units"
    t.boolean "active", default: false
  end

  create_table "previous_order_criteria", force: :cascade do |t|
    t.decimal "minimum_previous_orders_amount"
    t.integer "number_of_minimum_orders_quantity"
    t.integer "number_of_minimum_orders"
    t.boolean "special_period", default: false
    t.datetime "orders_from"
    t.datetime "orders_till"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.decimal "price", precision: 12, scale: 2
    t.integer "stock"
    t.integer "discount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.text "description"
    t.string "category"
    t.text "ingredients"
    t.string "food_type", default: "vegetarian"
    t.integer "min_quantity", default: 10
    t.string "min_quantity_unit", default: "gram"
    t.string "slug"
    t.boolean "tax_inclusive", default: false
    t.index ["slug"], name: "index_products_on_slug"
  end

  create_table "refunds", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "order_id"
    t.bigint "subscription_id"
    t.decimal "amount", precision: 12, scale: 2
    t.text "comments"
    t.boolean "complete", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_refunds_on_order_id"
    t.index ["subscription_id"], name: "index_refunds_on_subscription_id"
    t.index ["user_id"], name: "index_refunds_on_user_id"
  end

  create_table "shopping_cart_items", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "shopping_cart_id"
    t.integer "quantity"
    t.decimal "amount", precision: 12, scale: 2
    t.decimal "tax_amount", precision: 12, scale: 2
    t.decimal "shipping_amount", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "packaging_amount", precision: 12, scale: 2
    t.index ["product_id"], name: "index_shopping_cart_items_on_product_id"
    t.index ["shopping_cart_id"], name: "index_shopping_cart_items_on_shopping_cart_id"
  end

  create_table "shopping_carts", force: :cascade do |t|
    t.bigint "user_id"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "coupon_code"
    t.index ["user_id"], name: "index_shopping_carts_on_user_id"
  end

  create_table "subscription_details", force: :cascade do |t|
    t.bigint "subscription_id"
    t.integer "units"
    t.datetime "last_dispatched_at"
    t.datetime "last_delivered_at"
    t.datetime "last_payment_received_at"
    t.decimal "last_payment_received", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscription_id"], name: "index_subscription_details_on_subscription_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "plan_id"
    t.boolean "active", default: false
    t.boolean "completed", default: false
    t.integer "remaining_units"
    t.decimal "amount", precision: 12, scale: 2
    t.boolean "to_be_returned", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "cancelled", default: false
    t.index ["plan_id"], name: "index_subscriptions_on_plan_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.string "tagger_type"
    t.bigint "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone_number"
    t.boolean "phone_number_verified", default: false
    t.boolean "guest", default: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
