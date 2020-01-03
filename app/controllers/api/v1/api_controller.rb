module Api::V1
	class ApiController < ApplicationController

		before_action :authenticate_user!
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

    def serialize_object object
      ActiveModelSerializers::SerializableResource.new(object, namespace: "Api::V1")
    end

    %w(data error).each do |str|
      define_method "render_#{str}" do |object, error_http_code = "422"|
        if str == "data"
          status = "success"
          if object.present?
            data = serialize_object(object)
          else
            data = []
          end
          errors = nil
          http_code = "200"
        else
          status = "failure"
          data = nil
          errors = object
          http_code = error_http_code
        end
        render json: { status: status, data: data, errors: errors }, status: http_code
      end
    end

    def render_save_data obj
      if obj.save
        render_data obj
      else
        render_error obj.errors.full_messages
      end
    end

    def render_not_found(exception)
      render_error "#{exception.model.constantize} not found", 404
    end

    def render_custom_error errors, status = :unprocessable_entity
      render json: {
          errors: errors
      }, status: status
    end

		private

		def authenticate_user!
			header = request.headers['Authorization']
      header = header.split(' ').last if header
      begin
        decoded = JsonWebToken.decode(header)
        @current_user = User.find(decoded[:user])
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: e.message }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { errors: e.message }, status: :unauthorized
      end
		end

	end
end
