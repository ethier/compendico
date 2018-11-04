class EmailsController < ApplicationController
  before_action :set_organization
  before_action :set_email, only: %i[show edit update destroy]

  def index
    @q = @organization.emails.ransack(params[:q])
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

  def update
    @email.assign_attributes(email_params)

    email = update_email(@email)

    if email.valid?
      email.save!

      flash[:success] = t(:email_updated, subject: email.address)
      redirect_to organization_emails_path(@organization)
    else
      flash[:alert] = email.errors.full_messages.join(', ')
      redirect_to action: :edit, id: email.id
    end
  end

  def destroy
    # Cannot allow the discard on org email addresses.
    if @email.organization.from_email_id == @email.id
      flash[:alert] = t(:primary_organization_email_addresses_cannot_be_deleted)
      redirect_to organization_emails_url
    end

    @email.discard
    redirect_to organization_emails_url, notice: t(:email_deleted)
  end

private

  def set_email
    @email = @organization.emails.kept.find params[:id]
  end

  def email_params
    params
      .require(:compendico_email)
      .permit(
        :address,
        :name,
        :sender
      )
  end

  def update_email(email)
    # TODO: Some logic to send out the confirmation on email addresses and accept the sender invite.
    return email
  end
end
