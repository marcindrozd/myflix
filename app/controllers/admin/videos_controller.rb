class Admin::VideosController < AdminController
  before_action :require_admin

  def new
    @video = Video.new
  end
end
