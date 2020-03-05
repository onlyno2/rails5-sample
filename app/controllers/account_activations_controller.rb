class AccountActivationsController < ApplicationController
  before_action :authenticate_user, only: [:edit]

  def edit
    if authenticated?
      log_in @user
      flash[:success] = 'Account activated!'
      redirect_to @user
    else
      flash[:danger] = 'Invalid activation link'
      redirect_to root_url
    end
  end

  private

  def authenticate_user
    @user = User.find_by(email: params[:email])
  end

  def authenticated?
    @user && !@user.activated? && @user.authenticated?(:activation, params[:id])
  end

  def activate_user
    @user.activate
  end
end
