class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, omniauth_providers: [:facebook]

  has_many :reviews, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_one :billing_address, as: :billing_a, dependent: :destroy
  has_one :shipping_address, as: :shipping_a, dependent: :destroy
  accepts_nested_attributes_for :billing_address, allow_destroy: true
  accepts_nested_attributes_for :shipping_address, allow_destroy: true

  validates :email, presence: true, email: true, uniqueness: true
  validates_confirmation_of :password
  validates :password, presence: true, unless: ->(u) { u.password.nil? }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.skip_confirmation!
      user.save!
    end
  end
end
