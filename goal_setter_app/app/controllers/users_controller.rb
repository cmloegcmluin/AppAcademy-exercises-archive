class UsersController < ApplicationController
  before_action :only_logged_in!, only: [:show]
  before_action :only_logged_out!, only: [:new, :create]

  def new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notices] = ["Welcome, #{@user.username}!"]
      login!(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
