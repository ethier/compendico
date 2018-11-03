class TagsController < ApplicationController
  before_action :set_parent_resource

  def index
    @q = @parent_resource.all_tags.ransack(address_cont: params[:q])
    @tags = @q.result(distinct: true)

    render json: {
      tags:         @tags.map { |e| { id: e.id, address: e.address } },
      total_count:  @tags.size
    }
  end

private

  def set_parent_resource
    @parent_resource =
      if params[:organization_id]
        current_user.organizations.find(params[:organization_id]).messages
      elsif params[:message_id]
        Compendico::Message.where(organization_id: find(params[:message_id]))
      end
  end
end