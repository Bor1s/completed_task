# frozen_string_literal: true

class CreateCreditAccountTransfers < ActiveRecord::Migration[5.1]
  def change
    create_table :credit_account_transfers do |t|
      t.string :amount
      t.string :subject
      t.string :receiver_multi
      t.datetime :date
      t.boolean :skip_mobile_tan

      t.references :account

      t.timestamps
    end
  end
end
