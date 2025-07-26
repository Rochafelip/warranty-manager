class RemoveConfirmableFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_columns :users, :confirmed_at, :confirmation_token, :confirmation_sent_at, :unconfirmed_email, if_exists: true
  end
end
