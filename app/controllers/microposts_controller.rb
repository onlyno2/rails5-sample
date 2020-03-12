class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_user,   only: :destroy
  before_action :image_size,     only: :create
  include MicropostsHelper

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'Micropost deleted'
    redirect_to request.referrer
  end

  private

  def micropost_params
    request_params = params.require(:micropost).permit(:content, :picture)
    puts request_params[:picture].size
    {
      content: request_params[:content],
      picture: upload_image(request_params[:picture])
    }
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end

  def image_size
    return if params[:micropost][:picture].size < 5.megabytes

    flash[:danger] = 'Upload error. File size must less than 5Mb'
    redirect_to root_url
  end
end
