class UsersController < ApplicationController
  before_action :authenticate_user, except: [:new, :create]
  def new
    @user = User.new
  end

  def create
    user_params = params.require(:user)
                        .permit([:first_name,
                        :last_name,
                        :email,
                        :password,
                        :password_confirmation])
    @user = User.new user_params
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'Thanks for signing up!'
    else
      render:new
    end
  end

  def edit
    @user = current_user
    if @user.id != params[:id].to_i
      redirect_to root_path, alert: 'Unauthorized Access!'
    end
  end

  def update
    @user = current_user
    user_params = params.require(:user)
                       .permit([:first_name,
                                :last_name,
                                :email])
    if @user.update user_params
      redirect_to root_path, notice: 'User Profile Updated'
    else
      render :edit
    end
  end

end
