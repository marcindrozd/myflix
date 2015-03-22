class Admin::VideosController < AdminController
  before_action :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)

    if @video.save
      flash[:success] = "Video added!"
      redirect_to new_admin_video_path
    else
      flash.now[:danger] = "Please fill in all the fields"
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :category_id, :large_cover, :small_cover, :video_url)
  end
end
