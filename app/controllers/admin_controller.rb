class AdminController < ApplicationController
  before_action :require_user
  before_action :require_admin

  private

  def require_admin
    redirect_to root_path if current_user.not_admin?
  end
end
