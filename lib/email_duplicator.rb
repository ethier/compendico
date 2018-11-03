class EmailDuplicator
  attr_reader :email

  def initialize(email_id)
    @email = Email.find(email_id)
  end

  def dup
    email = @email.dup
    email.send_at = @email.next_send_at
    email.save!
  end
end
