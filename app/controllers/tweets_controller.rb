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
    sentence_list = Tweet.all.map{ |tweet| tweet.content }
    exclusion_words = "is the be to of and a in that have I I'm I've I'd it for not on with he as you do at this but his by from they we say her she or an will my one all would there their what so up out if about who get which go me when make can like time no just him know take people into year your good some could them see other than then now look only come its over think also back after use two how our work first well way even new want because any these give day most us hasn't ain't aren't could've would've should've couldn't didn't had've he'll how'll how're how's might've she'd he'd she'll they're they're we're we've can't won't shouldn't wouldn't haven't I'm ? .".downcase().split(' ')
    word_list = sentence_list.map{ |sentence| sentence.split(' ')}.flatten.map{ |word| word.downcase() }
    filtered_words = word_list.filter{ |word| !exclusionWords.include?(word) }.filter{ |word| !word.include?('@') }.filter{ |word| !word.includes('http')}
    word_object = []
    filtered_words.each do |filtered_word|
      existing_word = word_object.find{ |word| word.text == filtered_word }
      index = word_object.find_index{ |word| word.text == filtered_word }
      if existing_word
        word_object = word_object.slice(0,index).concat({ text: word_object[index].text, value: (word_object[index].value + 1)}).concat(word_object.slice(index+1))
      } else {
        word_object = word_object.concat({ text: filtered_word, value: 1 })
      }
    }
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
