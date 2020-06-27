class RefreshController < ApplicationRecord
  before_action :authorized_refresh_by_access_request!

  def create
    session = JWTSession::Session.new(payload: claimless_payload, refresh_by_access_allowed: true)
    tokens = session.refresh_by_access_allowed do
      raise JWTSession::Errors::Unauthorized, 'Something is not right here!'
    end
    @csrf = tokens[:csrf]

    response.set_cookie(
      JWTSessions.access_cookie,
      value: tokens[:access],
      httponly: true,
      secure: Rails.env.production?
    )

    render :show, status: :ok, location: @csrf
  end
end
