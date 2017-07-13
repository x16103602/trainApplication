class User < ApplicationRecord
  has_many :tickets
  has_many :longtrains
    def self.create_from_omniauth(auth)
      create! do |user|
      #where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
        user.provider = auth.provider
        user.userid = auth.uid
        user.name = auth.info.name
        user.oauth_token = auth.credentials.token
        user.oauth_expires_at = Time.at(auth.credentials.expires_at)
        user.save!
      end
    end
end
