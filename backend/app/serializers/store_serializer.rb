class StoreSerializer < ApplicationSerializer
  def self.call(store)
    return nil if store.nil?

    {
      id: store.id,
      name: store.name,
      address: store.address,
      contact: store.contact,
      created_at: store.created_at,
      updated_at: store.updated_at
    }
  end
end
