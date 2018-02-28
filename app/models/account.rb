class Account < ApplicationRecord
  has_many :credit_account_transfers
end
