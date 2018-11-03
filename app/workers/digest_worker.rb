class DigestWorker
  include Sidekiq::Worker

  def perform(digest_id, send_at)
    digest = Digest.find(digest_id)

    if digest.send_at == send_at && digest.messages.any?
      DigestMailer.send(digest_id).deliver

      # TODO
      # Update state and clone to make new digest.
    end
  end
end