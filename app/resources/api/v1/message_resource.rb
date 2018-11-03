module Api
  module V1
    class MessageResource < BaseResource
      model_name 'Compendico::Message'

      attributes :text, :data, :external_id, :tag_list

      relationship :template, to: :one
      relationship :digests, to: :many, acts_as_set: true

      filters :id, :text, :data, :external_id
    end
  end
end

