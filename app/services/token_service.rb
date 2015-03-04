class TokenService
  def self.create_for(klass, field = :token)
    token = loop do
      random_token = SecureRandom::uuid
      break random_token unless klass.exists?(field => random_token)
    end
  end
end