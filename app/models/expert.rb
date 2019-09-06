class Expert < ApplicationRecord
  belongs_to :account

  # Add busy status
  enum online_status: [:offline, :online, :away, :busy]
end
