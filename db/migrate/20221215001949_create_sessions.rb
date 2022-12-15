# frozen_string_literal: true

class CreateSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :sessions, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :user_agent
      t.inet :created_from
      t.inet :last_accessed_from
      t.datetime :last_accessed_at
      t.datetime :expires_at

      t.timestamps
    end
  end
end
