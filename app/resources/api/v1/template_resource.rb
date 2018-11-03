module Api
  module V1
    class TemplateResource < BaseResource
      model_name 'Compendico::Template'

      attributes :name, :category, :markup, :external_id

      relationship :messages, to: :many
      relationship :digests, to: :many

      filters :id, :name, :category, :external_id
    end
  end
end