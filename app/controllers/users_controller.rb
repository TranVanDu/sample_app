class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :find_user, only: %i(show edit destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @users = User.paginate(page: params[:page], per_page: Settings.per_pages)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      log_in @user
      flash[:success] = t "users_controller.content"
      redirect_to @user
    else
      flash.now[:danger] = t "users_controller.error"
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update user_params
      flash.now[:success] = t "users_controller.content2"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users_controller.content3"
      redirect_to users_url
    else
      flash[:error] = t "users_controller.error2"
      redirect_to root_url
    end
  end

  def find_user
    @user = User.find_by id: params[:id]

    return if @user
    redirect_to root_path
    flash[:danger] = t "users_controller.error3"
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "users_controller.content4"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
