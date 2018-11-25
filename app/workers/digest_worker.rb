class DigestWorker
  include Sidekiq::Worker

  def perform(digest_id, send_at)
    digest = Digest.find(digest_id)

    if digest.eligible_to_send?(send_at)
      DigestMailer.send(digest_id).deliver

      digest.sent!
    end
  end
end
