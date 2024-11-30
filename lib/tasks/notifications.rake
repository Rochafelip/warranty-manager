namespace :notifications do
    desc "Envia notificações para garantias próximas da expiração"
    task send_expiration_alerts: :environment do
      Warranty.where("expirity_date <= ?", 7.days.from_now).find_each do |warranty|
        NotificationJob.perform_later(warranty)
      end
    end
  end
  