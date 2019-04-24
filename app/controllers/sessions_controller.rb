class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      login_with_remember user
      redirect_back_or user
      flash[:success] = t "helpers.controller.session.success"
    else
      flash.now[:danger] = t "helpers.controller.session.error"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    flash.now[:success] = t "helpers.controller.session.log_out"
    redirect_to root_url
  end

  def login_with_remember user
    log_in user
    param = params[:session][:remember_me]
    param == Settings.one ? remember(user) : forget(user)
  end
end
