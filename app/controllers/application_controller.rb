class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  def test
    render json: "daaa"
  end

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: {error: 'Not Authorized'}, status: 401 unless @current_user
  end

  def authenticate_request_optional
    @current_user = AuthorizeApiRequest.call(request.headers).result
  end
end
