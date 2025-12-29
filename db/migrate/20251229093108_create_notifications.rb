class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true

      # actor - кто совершил действие (полиморфная связь)
      t.references :actor, polymorphic: true, null: false

      # notifiable - на что совершено действие (пост, комментарий и т.д.)
      t.references :notifiable, polymorphic: true, null: false

      t.string :action, null: false  # liked, commented, subscribed и т.д.
      t.string :message, null: false
      t.boolean :read, default: false

      t.timestamps
    end

    # Добавляем индексы для быстрого поиска
    add_index :notifications, [:user_id, :read]
    add_index :notifications, [:notifiable_id, :notifiable_type]
  end
end
