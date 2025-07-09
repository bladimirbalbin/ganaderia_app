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

ActiveRecord::Schema[7.1].define(version: 2025_07_09_060000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "animal_events", force: :cascade do |t|
    t.string "event_type"
    t.date "event_date"
    t.text "description"
    t.bigint "animal_id", null: false
    t.bigint "user_id", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["animal_id"], name: "index_animal_events_on_animal_id"
    t.index ["company_id"], name: "index_animal_events_on_company_id"
    t.index ["user_id"], name: "index_animal_events_on_user_id"
  end

  create_table "animals", force: :cascade do |t|
    t.string "name"
    t.string "breed"
    t.date "birth_date"
    t.decimal "weight"
    t.string "gender"
    t.string "ear_tag"
    t.string "status"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "animal_type"
    t.text "observations"
    t.index ["company_id"], name: "index_animals_on_company_id"
  end

  create_table "births", force: :cascade do |t|
    t.bigint "animal_id", null: false
    t.date "birth_date"
    t.string "calf_gender"
    t.decimal "calf_weight"
    t.string "calf_name"
    t.text "notes"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["animal_id"], name: "index_births_on_animal_id"
    t.index ["company_id"], name: "index_births_on_company_id"
  end

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
    t.string "subscription_status", default: "free"
    t.index ["membership_plan_id"], name: "index_companies_on_membership_plan_id"
  end

  create_table "customers", force: :cascade do |t|
    t.bigint "user_id"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id", null: false
    t.index ["company_id"], name: "index_customers_on_company_id"
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "inseminations", force: :cascade do |t|
    t.bigint "animal_id", null: false
    t.string "bull_name"
    t.date "insemination_date"
    t.string "technician"
    t.text "notes"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["animal_id"], name: "index_inseminations_on_animal_id"
    t.index ["company_id"], name: "index_inseminations_on_company_id"
  end

  create_table "medical_records", force: :cascade do |t|
    t.bigint "animal_id", null: false
    t.date "date"
    t.text "diagnosis"
    t.text "treatment"
    t.string "veterinarian"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["animal_id"], name: "index_medical_records_on_animal_id"
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

  create_table "milk_productions", force: :cascade do |t|
    t.bigint "animal_id", null: false
    t.date "production_date"
    t.decimal "quantity"
    t.string "period"
    t.text "notes"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["animal_id"], name: "index_milk_productions_on_animal_id"
    t.index ["company_id"], name: "index_milk_productions_on_company_id"
  end

  create_table "palpations", force: :cascade do |t|
    t.bigint "animal_id", null: false
    t.date "palpation_date"
    t.string "result"
    t.string "veterinarian"
    t.text "notes"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["animal_id"], name: "index_palpations_on_animal_id"
    t.index ["company_id"], name: "index_palpations_on_company_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_permissions_on_name", unique: true
  end

  create_table "role_permissions", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "permission_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "index_role_permissions_on_permission_id"
    t.index ["role_id", "permission_id"], name: "index_role_permissions_on_role_id_and_permission_id", unique: true
    t.index ["role_id"], name: "index_role_permissions_on_role_id"
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

  create_table "weight_records", force: :cascade do |t|
    t.bigint "animal_id", null: false
    t.date "weight_date"
    t.decimal "weight"
    t.text "notes"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "method"
    t.string "condition"
    t.index ["animal_id"], name: "index_weight_records_on_animal_id"
    t.index ["company_id"], name: "index_weight_records_on_company_id"
  end

  add_foreign_key "animal_events", "animals"
  add_foreign_key "animal_events", "companies"
  add_foreign_key "animal_events", "users"
  add_foreign_key "animals", "companies"
  add_foreign_key "births", "animals"
  add_foreign_key "births", "companies"
  add_foreign_key "companies", "membership_plans"
  add_foreign_key "customers", "companies"
  add_foreign_key "customers", "users"
  add_foreign_key "inseminations", "animals"
  add_foreign_key "inseminations", "companies"
  add_foreign_key "medical_records", "animals"
  add_foreign_key "milk_productions", "animals"
  add_foreign_key "milk_productions", "companies"
  add_foreign_key "palpations", "animals"
  add_foreign_key "palpations", "companies"
  add_foreign_key "role_permissions", "permissions"
  add_foreign_key "role_permissions", "roles"
  add_foreign_key "users", "companies"
  add_foreign_key "users", "roles"
  add_foreign_key "weight_records", "animals"
  add_foreign_key "weight_records", "companies"
end
