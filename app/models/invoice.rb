class Invoice < ApplicationRecord
  has_one_attached :pdf
  belongs_to :user
  has_many :products, dependent: :destroy

  validates :invoice_number, presence: true,
                             format: { with: /\A[a-zA-Z0-9]+\z/, message: 'deve conter apenas letras e números!' }
  validates :purchase_date, presence: true
  validates :issue_date, presence: true
  validates :pdf, presence: true
  validates :user_id, presence: true
  validate :purchase_date_cannot_be_after_issue_date

  private

  def purchase_date_cannot_be_after_issue_date
    return unless purchase_date > issue_date

    errors.add(:purchase_date, 'não pode ser posterior à data de emissão')
  end
end
