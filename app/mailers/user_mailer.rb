class UserMailer < ApplicationMailer
  def warranty_expiration_notification(user, warranty)
    @user = user
    @warranty = warranty
    mail(to: @user.email, subject: 'Sua garantia está próxima de expirar!')
  end
end
