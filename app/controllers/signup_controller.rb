class SignupController < ApplicationController
  def create
    user = User.new(user_params)

    if user.save
      payload = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      tokens = session.login
      @csrf = tokens[:csrf]

      response.set_cookie(
        JWTSessions.access_cookie,
        value: tokens[:access],
        httponly: true,
        secure: Rails.env.production?
      )

      render :show, status: :ok, location: @csrf
    else
      not_authorized
    end
  end

  private

  def not_authorized
    render json: { error: user.error.full_messages.join(' ') }, status: :unprocessible_entity
  end

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
