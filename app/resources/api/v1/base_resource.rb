module Api
  module V1
    class BaseResource < JSONAPI::Resource
      abstract

      before_save do
        @model.organization_id = context[:current_organization].id if @model.new_record?
      end
    end
  end
end