class OrganizationsController < ApplicationController
  before_action :set_organization, except: %i[new create]
  before_action :set_plans, only: %i[new edit]
  before_action :set_mail_services, only: %i[new edit]

  def new
    @organization = current_user.organizations.new
    @organization.build_from_email
    @data_no_turbolink = true
  end

  def show
    @q = @organization.digests.ransack(params[:q])
    @digests = @q.result(distinct: true)
    @digests_is_active = true
  end

  def create
    organization = Compendico::Organization.new(organization_params)
    organization.from_email.organization = organization

    if organization.valid?
      organization.save!
      organization.users << current_user

      redirect_to action: :show, id: organization.id
    else
      flash[:alert] = organization.errors.full_messages.join(', ')
      redirect_to action: :new
    end
  end

  def edit
  end

  def update
    email_attributes = organization_params[:from_email_attributes]
    @organization.attributes = organization_params.except(:from_email_attributes)

    if @organization.from_email.try(:organization) != @organization
      @organization.from_email.organization = @organization
    end

    if @organization.valid?
      @organization.save!

      redirect_to action: :show, id: @organization.id
    else
      flash[:alert] = @organization.errors.full_messages.join(', ')
      redirect_to action: :edit, id: @organization.id
    end
  end

  def destroy
    @organization.discard
    redirect_to account_url, notice: t(:organization_deleted)
  end

private

  def set_organization
    @organization = current_user.organizations.find params[:id]
  end

  def set_plans
    @plans = Compendico::Plan.publicly_available
  end

  def set_mail_services
    @mail_services = Compendico::MailService.publicly_available
  end

  def organization_params
    params
      .require(:compendico_organization)
      .permit(
        :name,
        :website,
        :plan_id,
        :webhook_callback_url,
        :mail_service_id,
        :mail_service_api_key,
        from_email_attributes: [
          :id,
          :address
        ]
      )
  end
end
