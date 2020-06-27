class SigninController < ApplicationController
  before_action :authorize_access_request, only: [:destroy]

  def create
    user = User.find_by(enail: params[:email])

    if user.authenticate(params[:password])
      payload = { user_id: user.id }
      session = JWTSession::Session.new(payload: payload, refresh_by_access_allowed: true)
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
      not_found
    end
  end

  def destroy
    session = JWTSession::Session.new(payload: payload)
    session.flush_by_access_payload
  end

  private

  def not_found
    render json: { error: 'Cannot find email and password combination' }, status: :not_found
  end
end
