# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.string :name
    t.index ["name"], name: "index_users_on_name"
  end

  create_table :articles, force: true do |t|
    t.string :name
    t.integer :user_id
    t.index ["name"], name: "index_articles_on_name"
    t.index ["user_id"], name: "index_articles_on_user_id"
  end
end
