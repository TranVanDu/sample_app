class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params

    if @micropost.save
      flash[:success] = t ".controller.success1"
      redirect_to root_url
    else
      @feed_items = []
      flash[:danger] = t ".controller.error1"
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash.now[:success] = t ".controller.success2"
      redirect_to request.referer || root_url
    else
      flash[:danger] = t ".controller.error2"
      redirect_to request.referer
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :picture)
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url if @micropost.blank?
  end
end
