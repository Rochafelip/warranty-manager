class User < ApplicationRecord
  has_many :invoices
  has_many :product_histories, dependent: :destroy

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :lockable

  include DeviseTokenAuth::Concerns::User

  enum role: { user: 0, admin: 1 }

  validates :name, presence: true, length: { minimum: 3, maximum: 50 },
                   format: { with: /\A[a-zA-Z\s]+\z/, message: 'Utilize somente letras' }

  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: 'Digite um endereço de e-mail válido' }
end
