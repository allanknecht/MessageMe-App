class UsersController < ApplicationController
  before_action :require_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :require_no_user, only: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Welcome to the MessageMe family!"
      redirect_to root_path
    else
      flash.now[:alert] = "Something went wrong"
      render "new"
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Your account was updated successfully"
      redirect_to user_path(@user)
    else
      flash.now[:alert] = "Something went wrong"
      render "edit"
    end
  end

  def index
    @users = User.all
  end

  def destroy
    if @user == current_user
      @user.destroy
      session[:user_id] = nil
      flash[:notice] = "Account deleted successfully"
      redirect_to root_path
    else
      flash[:alert] = "You can only delete your own account"
      redirect_to users_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Something went wrong while trying to find the user"
    redirect_to users_path
  end
end
