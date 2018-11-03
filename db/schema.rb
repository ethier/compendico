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

ActiveRecord::Schema.define(version: 2017_07_04_013211) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "compendico_digest_messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "digest_id"
    t.uuid "message_id"
    t.string "state"
    t.datetime "sent_at"
    t.jsonb "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["digest_id"], name: "index_compendico_digest_messages_on_digest_id"
    t.index ["message_id"], name: "index_compendico_digest_messages_on_message_id"
  end

  create_table "compendico_digests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "subject"
    t.uuid "to_email_id"
    t.uuid "from_email_id"
    t.uuid "organization_id"
    t.uuid "template_id"
    t.text "full_message"
    t.datetime "sending_at"
    t.datetime "sent_at"
    t.datetime "failed_at"
    t.integer "frequency"
    t.string "interval"
    t.datetime "send_at"
    t.string "state"
    t.jsonb "data", default: {}
    t.text "text"
    t.string "external_id"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_compendico_digests_on_discarded_at"
    t.index ["from_email_id"], name: "index_compendico_digests_on_from_email_id"
    t.index ["organization_id"], name: "index_compendico_digests_on_organization_id"
    t.index ["template_id"], name: "index_compendico_digests_on_template_id"
    t.index ["to_email_id", "from_email_id", "organization_id", "subject"], name: "to_from_organization_subject", unique: true
    t.index ["to_email_id"], name: "index_compendico_digests_on_to_email_id"
  end

  create_table "compendico_emails", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organization_id"
    t.string "localpart"
    t.string "domain"
    t.string "address"
    t.datetime "last_sent_at"
    t.boolean "sender", default: false
    t.uuid "sender_invite_token"
    t.datetime "sender_invite_sent_at"
    t.datetime "sender_invite_accepted_at"
    t.jsonb "data", default: {}
    t.string "external_id"
    t.integer "to_email_count", default: 0, null: false
    t.integer "from_email_count", default: 0, null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address", "organization_id"], name: "index_compendico_emails_on_address_and_organization_id", unique: true
    t.index ["discarded_at"], name: "index_compendico_emails_on_discarded_at"
    t.index ["organization_id"], name: "index_compendico_emails_on_organization_id"
  end

  create_table "compendico_mail_services", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "publicly_available", default: false
    t.string "class_name"
    t.jsonb "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "compendico_messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organization_id"
    t.uuid "template_id"
    t.text "text"
    t.jsonb "data", default: {}
    t.string "external_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_compendico_messages_on_organization_id"
    t.index ["template_id"], name: "index_compendico_messages_on_template_id"
  end

  create_table "compendico_organization_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organization_id"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_compendico_organization_users_on_organization_id"
    t.index ["user_id"], name: "index_compendico_organization_users_on_user_id"
  end

  create_table "compendico_organizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "api_key"
    t.string "encrypted_shared_secret"
    t.string "encrypted_shared_secret_iv"
    t.string "encrypted_mail_service_api_key"
    t.string "encrypted_mail_service_api_key_iv"
    t.uuid "plan_id"
    t.uuid "mail_service_id"
    t.integer "credits", default: 100
    t.boolean "renew_automatically", default: false
    t.jsonb "data", default: {}
    t.integer "templates_count", default: 0, null: false
    t.integer "digests_count", default: 0, null: false
    t.integer "emails_count", default: 0, null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "from_email_id"
    t.index ["discarded_at"], name: "index_compendico_organizations_on_discarded_at"
    t.index ["mail_service_id"], name: "index_compendico_organizations_on_mail_service_id"
    t.index ["plan_id"], name: "index_compendico_organizations_on_plan_id"
  end

  create_table "compendico_plans", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.integer "credits"
    t.boolean "publicly_available", default: false
    t.jsonb "details", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "compendico_templates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organization_id"
    t.string "category"
    t.string "name"
    t.text "markup"
    t.integer "external_id"
    t.jsonb "data", default: {}
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_compendico_templates_on_discarded_at"
    t.index ["organization_id", "name", "category"], name: "index_templates_on_organization_id_name_and_category", unique: true
    t.index ["organization_id"], name: "index_compendico_templates_on_organization_id"
  end

  create_table "compendico_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.jsonb "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_compendico_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_compendico_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_compendico_users_on_reset_password_token", unique: true
  end

  create_table "compendico_web_addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organization_id"
    t.string "category"
    t.string "scheme"
    t.string "host"
    t.string "port"
    t.string "path"
    t.string "query"
    t.string "fragment"
    t.string "address"
    t.jsonb "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address"], name: "index_compendico_web_addresses_on_address"
    t.index ["organization_id"], name: "index_compendico_web_addresses_on_organization_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.uuid "taggable_id"
    t.string "tagger_type"
    t.uuid "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.uuid "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "compendico_digest_messages", "compendico_digests", column: "digest_id"
  add_foreign_key "compendico_digest_messages", "compendico_messages", column: "message_id"
  add_foreign_key "compendico_digests", "compendico_organizations", column: "organization_id"
  add_foreign_key "compendico_digests", "compendico_templates", column: "template_id"
  add_foreign_key "compendico_emails", "compendico_organizations", column: "organization_id"
  add_foreign_key "compendico_messages", "compendico_organizations", column: "organization_id"
  add_foreign_key "compendico_messages", "compendico_templates", column: "template_id"
  add_foreign_key "compendico_organization_users", "compendico_organizations", column: "organization_id"
  add_foreign_key "compendico_organization_users", "compendico_users", column: "user_id"
  add_foreign_key "compendico_organizations", "compendico_mail_services", column: "mail_service_id"
  add_foreign_key "compendico_organizations", "compendico_plans", column: "plan_id"
  add_foreign_key "compendico_templates", "compendico_organizations", column: "organization_id"
  add_foreign_key "compendico_web_addresses", "compendico_organizations", column: "organization_id"
end
