class CreateTweets < ActiveRecord::Migration[6.1]
  def change
    create_table :tweets do |t|
      t.string :content
      t.string :twitter_id
      t.integer :feed_id

      t.timestamps
    end
  end
end
