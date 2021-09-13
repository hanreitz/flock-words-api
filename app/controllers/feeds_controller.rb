class FeedsController < ApplicationController
  require 'rest-client'
  before_action :set_feed, only: [:show, :update, :destroy]

  # GET /feeds
  def index
    @feeds = Feed.all

    render json: @feeds
  end

  # GET /feeds/1
  def show
    render json: @feed
  end

  # POST /feeds

  def validate_handle(handle)
    if handle.include?('@')
      handle = handle.slice(1)
    end
    bearer = ENV["BEARER_TOKEN"]
    url = "https://api.twitter.com/2/users/by/username/#{handle}"
    headers = {'Authorization': "Bearer #{bearer}"}
    response = JSON.parse(RestClient.get(url, headers))
    return response
  end

  def get_tweets(twitter_user_id)
    bearer = ENV["BEARER_TOKEN"]
    headers = {'Authorization': "Bearer #{bearer}"}
    tweet_url = "https://api.twitter.com/2/users/#{twitter_user_id}/tweets?expansions=author_id&tweet.fields=created_at&max_results=20"
    tweets_response = JSON.parse(RestClient.get(tweet_url, headers))
    return tweets_response["data"]
  end
  
  def create
    check_handle = validate_handle(feed_params[:handle])
    if check_handle["errors"]
      render json: { message: check_handle["errors"][0]["detail"] }
    else
      feed = Feed.new(feed_params)
      if feed.save
        feed_tweets = get_tweets(check_handle["data"]["id"])
        feed_tweets.each do |datum|
          Tweet.create(twitter_id: datum["id"], content: datum["text"], feed_id: feed.id, created_at: datum["created_at"])
        end
        render json: feed, status: :created, location: feed
      else
        render json: feed.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /feeds/1
  def update
    if @feed.update(feed_params)
      render json: @feed
    else
      render json: @feed.errors, status: :unprocessable_entity
    end
  end

  # DELETE /feeds/1
  def destroy
    @feed.tweets.destroy_all
    @feed.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feed
      @feed = Feed.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def feed_params
      params.require(:feed).permit(:handle, :user_id)
    end
end
