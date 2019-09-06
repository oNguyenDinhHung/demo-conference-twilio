class CreateExperts < ActiveRecord::Migration[5.2]
  def change
    create_table :experts do |t|
      t.references :account, foreign_key: true
      t.integer :online_status

      t.timestamps
    end
  end
end
