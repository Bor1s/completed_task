# frozen_string_literal: true

# NOTE: I didn't change anything
# in this class.
module Mraba
  class Transaction
    def self.define_dtaus(*)
      new
    end

    def valid_sender?(*); end

    def add_buchung(*); end

    def add_datei(*); end
  end
end
