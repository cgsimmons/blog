class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Password successfully changed."
    else
      flash.now[:alert] = @user.errors.full_messages.join(", ")
      render :edit
    end
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      # redirect_to root
    else
      flash.now[:alert] = "Email address not found"
      render :new
    end
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    unless (@user && @user.authenticated?(:reset, params[:id]))
      redirect_to root_path
    end
  end

  def user_params
     params.require(:user).permit(:password, :password_confirmation)
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:alert] = 'Password reset has expired.  Please try again.'
      redirect_to new_password_reset_path
    end
  end

end
