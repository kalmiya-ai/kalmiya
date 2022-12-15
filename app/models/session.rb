# frozen_string_literal: true

# == Schema Information
#
# Table name: sessions
#
# @!attribute id
#   @return [String]
# @!attribute created_from
#   @return [String]
# @!attribute expires_at
#   @return [Time]
# @!attribute last_accessed_at
#   @return [Time]
# @!attribute last_accessed_from
#   @return [String]
# @!attribute user_agent
#   @return [String]
# @!attribute created_at
#   @return [Time]
# @!attribute updated_at
#   @return [Time]
# @!attribute user_id
#   @return [String]
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Session < ApplicationRecord
  include ScopeInverter

  JWT_ALGORITHM = 'ED25519'
  JWT_DECODE_OPTS = {
    algorithm: JWT_ALGORITHM,
    nbf_leeway: 30,
    verify_iat: true
  }.freeze
  JWT_PRIVATE_KEY = RbNaCl::Signatures::Ed25519::SigningKey.new(
    Base64.decode64(ENV.fetch('KALMIYA_JWT_PRIVATE_KEY', Rails.application.credentials.jwt_private_key))
  ).freeze
  JWT_PUBLIC_KEY = RbNaCl::Signatures::Ed25519::VerifyKey.new(
    Base64.decode64(ENV.fetch('KALMIYA_JWT_PUBLIC_KEY', Rails.application.credentials.jwt_public_key))
  ).freeze

  belongs_to :user

  before_save :extend_life

  scope :active,  -> { where(expires_at: Time.zone.now..) }
  scope :expired, -> { inverse_of(:active)                }

  class << self
    def from_jwt(jwt)
      payload, = JWT.decode(jwt, JWT_PUBLIC_KEY, true, JWT_DECODE_OPTS)
      active.find_by!(id: payload['jti'], user_id: payload['sub'])
    end
  end

  def as_jwt
    {
      sub: user_id,
      exp: expires_at.to_i,
      nbf: iat,
      iat:,
      jti: id
    }
  end

  def to_jwt
    JWT.encode(as_jwt, JWT_PRIVATE_KEY, JWT_ALGORITHM)
  end

  private

  def extend_life
    self.expires_at = 30.days.from_now
  end

  def iat
    @iat ||= created_at.to_i
  end
end
