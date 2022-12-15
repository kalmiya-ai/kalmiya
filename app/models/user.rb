# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
# @!attribute id
#   @return [String]
# @!attribute confirmation_token
#   @return [String]
# @!attribute confirmed_at
#   @return [Time]
# @!attribute email
#   @return [String]
# @!attribute name
#   @return [String]
# @!attribute password_digest
#   @return [String]
# @!attribute unconfirmed_email
#   @return [String]
# @!attribute created_at
#   @return [Time]
# @!attribute updated_at
#   @return [Time]
#
class User < ApplicationRecord
  include AttributeProtector

  has_secure_token :confirmation_token
  has_secure_password

  validates :email,
            confirmation: true,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: { case_sensitive: false }

  validates :name, presence: true

  validates :unconfirmed_email,
            confirmation: { allow_blank: true },
            format: { allow_blank: true, with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: { allow_blank: true, case_sensitive: false },
            'validations/cross_uniqueness': { against: :email, allow_blank: true, case_sensitive: false }

  protect_attributes %i[confirmation_token
                        email_confirmation
                        password
                        password_confirmation
                        password_digest
                        unconfirmed_email
                        unconfirmed_email_confirmation]

  scope :confirmed, -> { where.not(confirmed_at: nil) }

  def confirmed?
    confirmed_at?
  end
end
