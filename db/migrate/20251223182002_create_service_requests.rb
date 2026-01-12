class CreateServiceRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :service_requests do |t|
      # STI Column
      t.string :type, null: false, index: true

      # Core fields
      t.references :requester, null: false, foreign_key: { to_table: :users }
      t.references :learner, null: false, foreign_key: { to_table: :users }
      t.string :status, default: 'pending', null: false
      t.text :reason

      # STI Specific Fields (Nullable)
      t.references :target_hub, foreign_key: { to_table: :hubs } # For HubTransferRequest
      t.string :certificate_type # For CertificateRequest

      t.timestamps
    end

    add_index :service_requests, :status
  end
end
