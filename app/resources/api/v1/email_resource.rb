module Api
  module V1
    class EmailResource < BaseResource
      model_name 'Compendico::Email'

      attributes :address, :external_id

      relationship :sent_digests, to: :many
      relationship :received_digests, to: :many

      filters :id, :address, :external_id
    end
  end
end