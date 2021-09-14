class AddTwitterUserIdToFeeds < ActiveRecord::Migration[6.1]
  def change
    add_column :feeds, :twitter_user_id, :string
  end
end
