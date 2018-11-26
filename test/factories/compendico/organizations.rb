FactoryBot.define do
  factory :organization, class: Compendico::Organization do
    name { 'Test Organization' }
    plan
    mail_service

    after(:build) do |organization, evaluator|
      organization.from_email = create(:from_email, organization: organization)
    end
  end
end
