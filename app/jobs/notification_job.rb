class NotificationJob < ApplicationJob
  queue_as :default

  def perform
    # Busca garantias próximas da expiração
    expiring_warranties = Warranty.where('expirity_date <= ?', Date.today + 7.days)

    expiring_warranties.each do |warranty|
      # Envia o e-mail usando UserMailer
      UserMailer.warranty_expiration_notification(warranty.user, warranty).deliver_later

      # Log para fins de depuração
      Rails.logger.info "Notificação enviada para usuário #{warranty.user.email} sobre a garantia #{warranty.id}"
    end
  end
end
