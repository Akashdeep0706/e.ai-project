module Api::V1
	class UsersController < ApiController

		before_action :check_user_exists, only: [:follow, :unfollow]
		before_action :check_user_already_follow?, only: [:follow]

		def follow
			follow = Follow.new(follower_id: @current_user.id, following_id: @user.id)
			render_save_data follow
		end

		def unfollow
			followed = Follow.find_by follower_id: @current_user.id, following_id: @user.id
			if followed.present?
				unfollow = followed.delete
				render_data unfollow
			else
				render_error "To unfollow #{@user.name}, you have to follow him/her first." 
			end
		end

		def show_current_user_follower
			followers = Follow.where(follower_id: @current_user.id).ids
			record = followers.map { |f|
				follow = Follow.find f
				user = User.find follow.following_id
			}
			render_data record
		end

		def show_current_user_followings
			following = Follow.where(following_id: @current_user.id).ids
			record = following.map { |f|
				follow = Follow.find f
				user = User.find follow.follower_id
			}
			render_data record
		end


		private

		def check_user_exists
			@user = User.find params[:user_id]
		end

		def check_user_already_follow?
			followed = Follow.find_by follower_id: @current_user.id, following_id: @user.id
			render_error "You already follow #{@user.name}" if followed.present?
		end

	end
end
