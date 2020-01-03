class RegistrationsController < Devise::RegistrationsController

  def create
    build_resource(sign_up_params)
    if resource.save
      render json: {data: resource, message: "Successful"}
    else
      render json: {data: false, message: "Some error in signup"}
    end
  end

  private

    def sign_up_params
      params.require(:user).permit(:email, :password, :phone, :name, :password_confirmation)
    end
end