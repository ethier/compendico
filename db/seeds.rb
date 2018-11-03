Compendico::Plan.create!(name: 'Developer', price: 0, credits: 100, publicly_available: true)
Compendico::Plan.create!(name: 'Lite', price: 10, credits: 1000, publicly_available: true)
Compendico::Plan.create!(name: 'Business', price: 20, credits: 5000, publicly_available: true)
Compendico::Plan.create!(name: 'Pro', price: 50, credits: 20000, publicly_available: true)

user = Compendico::User.new
user.email = 'derek.ethier@gmail.com'
user.password = 'testpassword'
user.password_confirmation = 'testpassword'
user.confirmed_at = Time.current
user.save!

Compendico::MailService.create!(name: 'Mandrill', description: 'Test mandrill description', publicly_available: true)
Compendico::MailService.create!(name: 'Sendgrid', description: 'Test sendgrid description', publicly_available: true)
Compendico::MailService.create!(name: 'Postmark', description: 'Test postmark description', publicly_available: true)
Compendico::MailService.create!(name: 'Mailgun', description: 'Test mailgun description', publicly_available: true)