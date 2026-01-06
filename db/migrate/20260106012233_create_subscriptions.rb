class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    # Удаляем таблицу если она существует
    drop_table :subscriptions if table_exists?(:subscriptions)

    # Создаем новую таблицу
    create_table :subscriptions do |t|
      t.integer :subscriber_id, null: false
      t.integer :subscribed_to_id, null: false
      t.timestamps
    end

    # Добавляем индексы
    add_index :subscriptions, :subscriber_id
    add_index :subscriptions, :subscribed_to_id
    add_index :subscriptions, [:subscriber_id, :subscribed_to_id], unique: true
  end
end
