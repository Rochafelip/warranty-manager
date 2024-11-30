class WarrantyExpirationNotificationJob
  include Sidekiq::Job

  def perform(user_id, warranty_id)
    user = User.find(user_id)
    warranty = Warranty.find(warranty_id)
    UserMailer.warranty_expiration_notification(user, warranty).deliver_now
  end
end
