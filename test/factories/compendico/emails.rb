FactoryBot.define do
  # Leave the organization out here.
  # Causes a recursion issue with the two-sided association.
  factory :from_email, class: Compendico::Email do
    address { 'from_email@example.com' }
  end

  factory :email, class: Compendico::Email do
    address { 'email@example.com' }
    organization
  end
end
