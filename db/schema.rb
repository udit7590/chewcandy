# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160123085006) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.string   "primary"
    t.integer  "user_id"
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.integer  "pincode"
    t.text     "full_address"
    t.datetime "verified_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_posts", force: true do |t|
    t.integer  "user_id"
    t.string   "slug"
    t.string   "title"
    t.boolean  "published"
    t.datetime "published_at"
    t.string   "markup_lang"
    t.text     "raw_content"
    t.text     "html_content"
    t.text     "html_overview"
    t.string   "video_url"
    t.string   "meta_description"
    t.string   "meta_image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "blog_posts", ["published_at"], name: "index_blog_posts_on_published_at", using: :btree
  add_index "blog_posts", ["slug"], name: "index_blog_posts_on_slug", unique: true, using: :btree
  add_index "blog_posts", ["user_id"], name: "index_blog_posts_on_user_id", using: :btree

  create_table "blogo_posts", force: true do |t|
    t.integer  "user_id",          null: false
    t.string   "permalink",        null: false
    t.string   "title",            null: false
    t.boolean  "published",        null: false
    t.datetime "published_at",     null: false
    t.string   "markup_lang",      null: false
    t.text     "raw_content",      null: false
    t.text     "html_content",     null: false
    t.text     "html_overview"
    t.string   "tags_string"
    t.string   "meta_description", null: false
    t.string   "meta_image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blogo_posts", ["permalink"], name: "index_blogo_posts_on_permalink", unique: true, using: :btree
  add_index "blogo_posts", ["published_at"], name: "index_blogo_posts_on_published_at", using: :btree
  add_index "blogo_posts", ["user_id"], name: "index_blogo_posts_on_user_id", using: :btree

  create_table "blogo_taggings", force: true do |t|
    t.integer "post_id", null: false
    t.integer "tag_id",  null: false
  end

  add_index "blogo_taggings", ["tag_id", "post_id"], name: "index_blogo_taggings_on_tag_id_and_post_id", unique: true, using: :btree

  create_table "blogo_tags", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blogo_tags", ["name"], name: "index_blogo_tags_on_name", unique: true, using: :btree

  create_table "blogo_users", force: true do |t|
    t.string   "name",            null: false
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blogo_users", ["email"], name: "index_blogo_users_on_email", unique: true, using: :btree

  create_table "cards", force: true do |t|
    t.string  "gateway_customer_profile_id"
    t.string  "gateway_payment_profile_id"
    t.string  "last4"
    t.integer "month"
    t.integer "year"
    t.string  "description"
    t.integer "user_id"
    t.string  "cc_type"
  end

  create_table "cash_on_deliveries", force: true do |t|
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.string   "title"
    t.text     "body"
    t.string   "subject"
    t.integer  "user_id",          null: false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "full_name"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "criteria", force: true do |t|
    t.integer  "actable_id"
    t.string   "actable_type"
    t.string   "name"
    t.boolean  "one_time"
    t.datetime "valid_from"
    t.datetime "valid_till"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "criteria_discounts", id: false, force: true do |t|
    t.integer  "discount_id",  null: false
    t.integer  "criterium_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "discounts", force: true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.string   "code"
    t.decimal  "amount"
    t.string   "unit"
    t.decimal  "max_amount"
    t.boolean  "active"
    t.datetime "deleted_at"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "discounts_orders", id: false, force: true do |t|
    t.integer  "discount_id", null: false
    t.integer  "order_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enquiries", force: true do |t|
    t.integer  "user_id"
    t.string   "from_email"
    t.string   "from_name"
    t.string   "about"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "festival_criteria", force: true do |t|
    t.string "name"
  end

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "min_order_criteria", force: true do |t|
    t.decimal "amount"
    t.integer "quantity"
  end

  create_table "orders", force: true do |t|
    t.integer  "user_id"
    t.integer  "shopping_cart_id"
    t.string   "state"
    t.decimal  "total_product_amount",   precision: 12, scale: 2
    t.decimal  "total_quantity",         precision: 12, scale: 2
    t.decimal  "total_tax_amount",       precision: 12, scale: 2
    t.decimal  "total_shipping_amount",  precision: 12, scale: 2
    t.string   "payment_method"
    t.boolean  "verified",                                        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "coupon_code"
    t.decimal  "discount_amount",        precision: 12, scale: 2
    t.string   "number"
    t.decimal  "total_packaging_amount", precision: 12, scale: 2
  end

  create_table "payments", force: true do |t|
    t.integer  "order_id"
    t.decimal  "amount",      precision: 8, scale: 2
    t.string   "state"
    t.integer  "source_id"
    t.string   "source_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["source_id", "source_type"], name: "index_payments_on_source_id_and_source_type", using: :btree

  create_table "plans", force: true do |t|
    t.string   "type"
    t.decimal  "price",       precision: 12, scale: 2
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "units"
    t.boolean  "active",                               default: false
  end

  create_table "previous_order_criteria", force: true do |t|
    t.decimal  "minimum_previous_orders_amount"
    t.integer  "number_of_minimum_orders_quantity"
    t.integer  "number_of_minimum_orders"
    t.boolean  "special_period",                    default: false
    t.datetime "orders_from"
    t.datetime "orders_till"
  end

  create_table "products", force: true do |t|
    t.string   "name"
    t.decimal  "price",              precision: 12, scale: 2
    t.integer  "stock"
    t.integer  "discount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "description"
    t.string   "category"
    t.text     "ingredients"
    t.string   "food_type",                                   default: "vegetarian"
    t.integer  "min_quantity",                                default: 10
    t.string   "min_quantity_unit",                           default: "gram"
    t.string   "slug"
    t.boolean  "tax_inclusive",                               default: false
  end

  add_index "products", ["slug"], name: "index_products_on_slug", using: :btree

  create_table "refunds", force: true do |t|
    t.integer  "user_id"
    t.integer  "order_id"
    t.integer  "subscription_id"
    t.decimal  "amount",          precision: 12, scale: 2
    t.text     "comments"
    t.boolean  "complete",                                 default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shopping_cart_items", force: true do |t|
    t.integer  "product_id"
    t.integer  "shopping_cart_id"
    t.integer  "quantity"
    t.decimal  "amount",           precision: 12, scale: 2
    t.decimal  "tax_amount",       precision: 12, scale: 2
    t.decimal  "shipping_amount",  precision: 12, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "packaging_amount", precision: 12, scale: 2
  end

  create_table "shopping_carts", force: true do |t|
    t.integer  "user_id"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "coupon_code"
  end

  create_table "subscription_details", force: true do |t|
    t.integer  "subscription_id"
    t.integer  "units"
    t.datetime "last_dispatched_at"
    t.datetime "last_delivered_at"
    t.datetime "last_payment_received_at"
    t.decimal  "last_payment_received",    precision: 12, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: true do |t|
    t.integer  "user_id"
    t.integer  "plan_id"
    t.boolean  "active",                                   default: false
    t.boolean  "completed",                                default: false
    t.integer  "remaining_units"
    t.decimal  "amount",          precision: 12, scale: 2
    t.boolean  "to_be_returned",                           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "cancelled",                                default: false
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number"
    t.boolean  "phone_number_verified",  default: false
    t.boolean  "guest",                  default: false
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
