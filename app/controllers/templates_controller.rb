class TemplatesController < ApplicationController
  before_action :set_organization
  before_action :set_template, only: %i[show edit update destroy]

  def index
    @q = @organization.templates.kept.ransack(params[:q])

    @templates = @q.result(distinct: true)

    @templates.order(:created_at).page(params[:page])

    @templates_is_active = true
  end

  def new
    templates = @organization.templates

    category = params[:category]

    @template =
      if category and Compendico::Template.categories.include?(category)
        templates.send(category.pluralize).new
      else
        templates.new
      end
  end

  def show
  end

  def create
    template = @organization.templates.new(template_params)

    if template.valid?
      template.save!

      redirect_to action: :index
    else
      flash[:alert] = template.errors.full_messages.join(', ')
      redirect_to action: :new
    end
  end

  def edit
  end

  def update
    @template.assign_attributes(template_params)

    if @template.valid?
      @template.save!

      redirect_to action: :index
    else
      flash[:alert] = template.errors.full_messages.join(', ')
      redirect_to action: :edit, template_id: @template.id
    end
  end

  def destroy
    @template.discard
    redirect_to organization_templates_url, notice: t(:template_deleted)
  end

private

  def set_template
    @template = @organization.templates.kept.find params[:id]
  end

  def template_params
    params
      .require(:compendico_template)
      .permit(
        :category,
        :name,
        :markup,
        :external_id
      )
  end
end
