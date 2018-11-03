module Api
  module V1
    class DigestResource < BaseResource
      model_name 'Compendico::Digest'

      relationship :to_email, to: :one
      relationship :from_email, to: :one
      relationship :template, to: :one

      relationship :messages, to: :many, acts_as_set: true

      attributes :subject, :frequency, :interval, :send_at, :external_id

      filters :id, :subject, :external_id, :messages, :to_email, :from_email
    end
  end
end