class CreateFeeds < ActiveRecord::Migration[6.1]
  def change
    create_table :feeds do |t|
      t.string :handle
      t.integer :user_id

      t.timestamps
    end
  end
end
