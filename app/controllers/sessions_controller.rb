class SessionsController < Devise::SessionsController
 
  def create
    user = User.find_by_email(login_params[:email])
    if user && user.valid_password?(login_params[:password])
      token = JsonWebToken.encode(user: user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                         user_name: user.name }, status: :ok
    else
    	render json: {message: "Invalid Email or Password"}
    end
  end

  private

    def login_params
      params.require(:user).permit(:email, :password)
    end

end