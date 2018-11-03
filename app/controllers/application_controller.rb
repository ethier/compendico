class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  before_action :set_paper_trail_whodunnit
  before_action :set_data_no_turbolink

  def after_sign_in_path_for(resource_or_scope)
    account_path
  end

private

  def set_organization
    @organization = current_user.organizations.find params[:organization_id]
  end

  def set_data_no_turbolink
    @data_no_turbolink = false
  end
end
