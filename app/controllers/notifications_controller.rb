class NotificationsController < ApplicationController
  def notify_expiring_warranties
    WarrantyNotificationWorker.perform_async
    render json: { status: 'success', message: 'Notificações enfileiradas com sucesso' }, status: :accepted
  end
end
