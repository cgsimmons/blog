class PasswordsController < ApplicationController
    before_action :authenticate_user

  def edit
    @user = current_user
    if @user.id != params[:user_id].to_i
      redirect_to root_path, alert: 'Unauthorized Access!'
    end
  end

  def update
    @user = current_user
    user_params = params.require(:user)
                       .permit([:old_password,
                                :password,
                                :password_confirmation])

    if !@user.authenticate(user_params[:old_password])
      flash[:notice] = 'Old password is invalid.'
      render :edit
    elsif @user.update({password: user_params[:password],
      password_confirmation: user_params[:password_confirmation]})
      redirect_to edit_user_path(@user), notice: 'Password Updated'
    else
      flash[:notice] = 'Password not changed.'
      render :edit
    end
  end
end
