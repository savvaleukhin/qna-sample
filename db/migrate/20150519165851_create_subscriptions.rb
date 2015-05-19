class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :subscriber_id
      t.integer :tracking_question_id

      t.timestamps null: false
    end
    add_index :subscriptions, :subscriber_id
    add_index :subscriptions, :tracking_question_id
    add_index :subscriptions, [:subscriber_id, :tracking_question_id], unique: true
  end
end
