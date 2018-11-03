class UserTokenController < Knock::AuthTokenController
  def entity_name
    'Compendico::User'
  end
end
