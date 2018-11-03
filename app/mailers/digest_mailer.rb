class DigestMailer < ApplicationMailer
  layout 'mailer'

  def send(id)
    @digest = Digest.find(id)

    subject = @digest.subject

    to    = @digest.to_email.address
    from  = @digest.from_email.address

    mail(to: to, from: from, subject: subject)
  end
end
