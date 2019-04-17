class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user&.authenticate(params[:session][:password])
      log_in user
      flash[:success] = t "helpers.controller.session.success"
      redirect_to user_path(id: user.id)
    else
      flash.now[:danger] = t "helpers.controller.session.error"
      render :new
    end
  end

  def destroy
    log_out
    flash.now[:success] = t "helpers.controller.session.log_out"
    redirect_to root_url
  end
end
