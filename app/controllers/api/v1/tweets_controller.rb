module Api::V1
	class TweetsController < ApiController

		def create 
			tweet = Tweet.new(tweet_params)
			tweet.user_id = @current_user.id 
			render_save_data tweet
		end

		def show_tweets
			follow_id = Follow.where(follower_id: @current_user.id).pluck(:following_id)
			ids = follow_id << @current_user.id
			record = Tweet.where(user_id: ids)
			render_data record.order('created_at DESC')
		end

		private

		def tweet_params
			params.require(:tweet).permit(:tweet)
		end

	end
end
