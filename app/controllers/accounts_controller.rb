class AccountsController < ApplicationController
  def show
    @organizations = current_user.organizations.kept
  end
end
