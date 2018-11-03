class EmailsController < ApplicationController
  before_action :set_organization
  before_action :set_email, only: %i[show edit update destroy]

  def index
    @q = @organization.emails.ransack(address_cont: params[:q])
    @emails = @q.result(distinct: true).order(:created_at)

    respond_to do |format|
      format.html
      format.json {
        render json: {
          emails: @emails.flat_map{ |e| { label: e.address, value: e.id } }
        }
      }
    end
  end

  def new
    @email = @organization.emails.new
  end

  def edit
  end

  def destroy
    # TODO: Cannot allow the discard on org email addresses.
    @email.discard
    redirect_to organization_emails_url, notice: t(:email_deleted)
  end

private

  def set_email
    @email = @organization.emails.kept.find params[:id]
  end
end
