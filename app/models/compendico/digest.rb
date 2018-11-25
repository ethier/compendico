# == Schema Information
#
# Table name: compendico_digests
#
#  id              :uuid             not null, primary key
#  subject         :string
#  to_email_id     :uuid
#  from_email_id   :uuid
#  organization_id :uuid
#  template_id     :uuid
#  full_message    :text
#  sending_at      :datetime
#  sent_at         :datetime
#  failed_at       :datetime
#  frequency       :integer
#  interval        :string
#  send_at         :datetime
#  state           :string
#  data            :jsonb
#  text            :text
#  external_id     :string
#  discarded_at    :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

module Compendico
  class Digest < ApplicationRecord
    include Discard::Model
    include TemplateParser

    ALLOWED_INTERVALS = %w(immediate hour day week month year).freeze

    has_paper_trail

    belongs_to :organization
    counter_culture :organization

    belongs_to  :to_email,
                class_name: 'Email',
                autosave: false
    counter_culture :to_email

    belongs_to  :from_email,
                class_name: 'Email',
                autosave: false,
                optional: true
    counter_culture :from_email

    ransack_alias :to_from_email_address, :to_email_address_or_from_email_address

    belongs_to :template, optional: true

    has_many :digest_messages
    has_many :messages, through: :digest_messages

    before_validation :set_send_at

    validates :subject, presence: true

    validate  :send_at_present_and_not_in_the_past

    validates :frequency, numericality: { only_integer: true }
    validates :interval, inclusion: { in: ALLOWED_INTERVALS }

    accepts_nested_attributes_for :to_email, :from_email
    accepts_nested_attributes_for :messages, reject_if: :all_blank, allow_destroy: true

    after_save :broadcast, if: :broadcastable?
    after_save :schedule_send

    state_machine initial: :queued do
      before_transition to: :sending, do: :before_sending_entry
      after_transition  to: :sending, do: :on_sending_entry
      after_transition  to: :sent,    do: :on_sent_entry
      after_transition  to: :failed,  do: :on_failed_entry

      event :start_sending do
        transition to: :sending, from: [:queued, :failed]
      end

      event :send_failed do
        transition to: :failed, from: [:queued, :sending, :sent]
      end

      state :sending do
        validates :sending_at, presence: true
      end

      state :sent do
        validates :sent_at, presence: true
      end

      state :failed do
        validates :failed_at, presence: true
      end
    end

    def self.intervals
      ALLOWED_INTERVALS
    end

    def from_email
      super || organization.from_email
    end

    def full_message
      super || render
    end

    def next_send_at
      send_at + eval("#{frequency}.#{interval}")
    end

    def render
      parsed_template.render(
        JSON.parse(data).merge("messages" => messages.map(&:render).join("\n"))
      )
    end

    def broadcast
      organization_digests = organization.digests

      ActionCable.server.broadcast(
        "digest_#{organization_id}",
        id:                   id,
        from:                 from_email.try(:address),
        to:                   to_email.try(:address),
        subject:              ActionController::Base.helpers.link_to(subject, Rails.application.routes.url_helpers.edit_organization_digest_path(organization, self)),
        frequency:            frequency,
        interval:             I18n.t("frequencies.#{interval}"),
        state:                I18n.t("states.digest.#{state}"),
        send_at:              I18n.l(send_at, format: :short),
        next_send_at:         I18n.l(next_send_at, format: :short),
        size:                 messages.try(:size),
        queued_digests_count: ActiveSupport::NumberHelper.number_to_human(organization_digests.with_state(:queued).try(:size)),
        sent_digests_count:   ActiveSupport::NumberHelper.number_to_human(organization_digests.with_state(:sent).try(:size)),
        failed_digests_count: ActiveSupport::NumberHelper.number_to_human(organization_digests.with_state(:failed).try(:size)),
        total_digests_count:  ActiveSupport::NumberHelper.number_to_human(organization_digests.try(:size))
      )
    end

    def eligible_to_send?(send_at)
      send_at == send_at &&
        messages.any? &&
        organization.active_plan?
    end

  private

    def set_send_at
      self.send_at = DateTime.now + 1.hour if send_at.nil?
    end

    def send_at_present_and_not_in_the_past
      if send_at.blank? || send_at < Date.today
        errors.add(:send_at, "required and can't be in the past")
      end
    end

    def before_sending_entry
      # Prep full message.
    end

    def on_sending_entry
      update_columns(:sending_at, Time.current)

      DigestMailer.send(uuid).deliver_later

      # TODO: Ensure new digest doesn't have any messages on it.
      new_digest = self.clone
      new_digest.save!
    end

    def on_sent_entry
      messages.update_columns(state: 'sent', sent_at: Time.current)

      update_columns(:sent_at, Time.current)

      EmailDuplicator.new(id).dup
    end

    def on_failed_entry
      messages.update_columns(state: 'queued', sent_at: nil)

      update_columns(:failed_at, Time.current)
    end

    def broadcastable?
      true
    end

    def schedule_send
      DigestWorker.perform_at(send_at, id, send_at)
    end
  end
end
