class DigestsController < ApplicationController
  before_action :set_organization
  before_action :set_digest, only: %i[show edit update destroy]
  before_action :set_templates, only: %i[new edit]

  def index
    @q = @organization.digests.kept.ransack(params[:q])

    @digests = @q.result(distinct: true)
    @digests = @digests.with_state(params[:filter]) if params[:filter]

    @digests.order(:created_at).page(params[:page])
  end

  def show
  end

  def new
    @digest = @organization.digests.new
  end

  def create
    digest = @organization.digests.build(digest_params)

    digest = update_digest(digest)

    if digest.valid?
      digest.save!

      flash[:success] = t(:digest_created, subject: digest.subject)
      redirect_to organization_digests_path(@organization)
    else
      flash[:alert] = digest.errors.full_messages.join(', ')
      redirect_to action: :new
    end
  end

  def edit
  end

  def update
    @digest.assign_attributes(digest_params)

    digest = update_digest(@digest)

    if digest.valid?
      digest.save!

      flash[:success] = t(:digest_updated, subject: digest.subject)
      redirect_to organization_digests_path(@organization)
    else
      flash[:alert] = digest.errors.full_messages.join(', ')
      redirect_to action: :edit, id: digest.id
    end
  end

  def destroy
    @digest.discard
    redirect_to organization_digests_url, notice: t(:digest_deleted)
  end

private

  def set_digest
    @digest = @organization.digests.find params[:id]
  end

  def set_templates
    @digest_templates = @organization.templates.kept.digests
    @message_templates = @organization.templates.kept.messages
  end

  def digest_params
    params
      .require(:compendico_digest)
      .permit(
        :subject,
        :frequency,
        :interval,
        :send_at,
        :markup,
        :template_id,
        :data,
        messages_attributes: [
          :text,
          :data,
          :template_id,
          :_destroy
        ]
      )
  end

  def update_digest(digest)
    digest.messages.each { |m| m.organization = @organization }

    digest.to_email =
      @organization
      .emails
      .where(
        address: params[:compendico_digest][:to_email]
      )
      .first_or_create

    digest.from_email =
      @organization
      .emails
      .where(
        address: params[:compendico_digest][:from_email]
      )
      .first_or_create

    digest
  end
end
