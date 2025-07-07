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

ActiveRecord::Schema[7.1].define(version: 2025_07_07_001358) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "contact_email"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_provider"
    t.string "membership_plan"
    t.integer "users_limit"
    t.date "active_until"
    t.bigint "membership_plan_id"
    t.index ["membership_plan_id"], name: "index_companies_on_membership_plan_id"
  end

  create_table "customers", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "company_id"
    t.integer "customer_type", default: 0, null: false
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "second_last_name"
    t.string "document_type"
    t.string "document_number"
    t.string "address1"
    t.string "address2"
    t.string "mobile_phone1"
    t.string "mobile_phone2"
    t.string "landline_phone"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_customers_on_company_id"
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "membership_plans", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price"
    t.integer "users_limit"
    t.integer "duration_in_days"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "role_id", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "companies", "membership_plans"
  add_foreign_key "customers", "companies"
  add_foreign_key "customers", "users"
  add_foreign_key "users", "companies"
  add_foreign_key "users", "roles"
end
