class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :update, :destroy]

  # GET /tweets
  def index
    @tweets = Tweet.all

    render json: @tweets
  end

  # GET /tweets/1
  def show
    render json: @tweet
  end

  # POST /tweets
  def create
    @tweet = Tweet.new(tweet_params)

    if @tweet.save
      render json: @tweet, status: :created, location: @tweet
    else
      render json: @tweet.errors, status: :unprocessable_entity
    end
  end

  def get_data
    sentence = Tweet.all.map{ |tweet| tweet.content }.join(' ').gsub(/[!#$%^&*()-=_+|;:",.<>?…—“”]/, '')
    word_list = sentence.split(' ').map{ |word| word.downcase() }
    exclusion_words = "is the be to of are was and a in that have I I'm I’m I've I’ve I'd I’d it for not on with he as you do at this but his by from they we say her she or an will my one all would there their what so up out if about who get which go me when make can like time no just him know take people into year your good some could them see other than then now look only come its over think also back after use two how our work first well way even new want because any these give day most us hasn't hasn’t ain't ain’t aren't aren’t could've could’ve would've would’ve should've should’ve couldn't couldn’t didn't didn’t had've had’ve he'll he’ll how'll how’ll how're how’re how's how’s might've might’ve she'd she’d he'd he’d she'll she’ll they're they’re we're we’re we've we’ve can't can’t won't won’t wouldn't wouldn’t couldn't couldn’t haven't haven’t rt link links you're you’re you've you’ve that's that’s they've they’ve don't don’t it's it’s amp must has more better got".downcase().split(' ')
    filtered_words = word_list.filter{ |word| !exclusion_words.include?(word) }.filter{ |word| !word.include?('@') }.filter{ |word| !word.include?('http')}
      word_object = []
      filtered_words.each do |filtered_word|
        existing_word = word_object.find{ |word| word[:text] == filtered_word }
      if existing_word
        existing_word[:value] = existing_word[:value] + 1
      else
        word_object.push({ text: filtered_word, value: 1 })
      end
    end
    render json: word_object
  end

  # PATCH/PUT /tweets/1
  def update
    if @tweet.update(tweet_params)
      render json: @tweet
    else
      render json: @tweet.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tweets/1
  def destroy
    @tweet.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tweet_params
      params.require(:tweet).permit(:content, :twitter_id, :feed_id)
    end
end
