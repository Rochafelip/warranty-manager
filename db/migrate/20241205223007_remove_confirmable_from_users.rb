class RemoveConfirmableFromUsers < ActiveRecord::Migration[7.0]
  def change
    if column_exists?(:users, :confirmation_token)
      remove_column :users, :confirmation_token
    end

    if column_exists?(:users, :confirmed_at)
      remove_column :users, :confirmed_at
    end

    if column_exists?(:users, :confirmation_sent_at)
      remove_column :users, :confirmation_sent_at
    end

    if column_exists?(:users, :unconfirmed_email)
      remove_column :users, :unconfirmed_email
    end
  end
end
