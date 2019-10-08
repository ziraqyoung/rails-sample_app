class PasswordResetsController < ApplicationController
  before_action :get_user, only: %i[edit update]
  before_action :valid_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'Email sent with password reset information'
      redirect_to root_url
    else
      flash.now[:danger] = 'Email address not found'
      render 'new'
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, 'Cant be empty')
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = 'Password reset successfully'
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  # gets a user by email
  def get_user
    @user = User.find_by(email: params[:email])
  end

  # user params
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # confirms that a user is valid
  def valid_user
    unless (
           @user && @user.activated? &&
             @user.authenticated?(:reset, params[:id])
         )
      redirect_to root_url
    end
  end

  # check reset token expiration date
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = 'Password reset has expired'
      redirect_to new_password_reset_url
    end
  end
end