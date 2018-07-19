class Api::V1::UsersController < ApplicationController

  skip_before_action :authenticate_request, :only => [:create]

  def create
    @user = User.new(user_params)
    if @user.save
      render status: 201, json: @user
    else
      render status: 400, json: {"message" => @user.errors}
    end
  end


  def profile
    render status: 200, json: @current_user
  end

  private

  def user_params
    params.require(:user).permit(:name, :surname, :email, :password,
                                 :password_confirmation)
  end
end

