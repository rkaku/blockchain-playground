require 'base58'
require 'openssl'
# require 'bigdecimal'
# require 'bigdecimal/util'

require_relative './helper.rb'


class Transaction

  def initialize(sender_priv_key, sender_pub_key, sender_address, recipient_address, value)
    @sender_priv_key = sender_priv_key
    @sender_pub_key = sender_pub_key
    @sender_address = sender_address
    @recipient_address = recipient_address
    @value = value
  end

  def transaction_object
    transaction = sort_dict_by_key({
      sender_address: @sender_address,
      recipient_address: @recipient_address,
      # value: @value.to_d.floor(8)
      value: @value
    })
  end

  def tran_obj
    transaction_object
  end

  def generate_signature
    # p sender_priv_key_obj = OpenSSL::PKey::EC.new(@sender_priv_key)
    # transaction = transaction_object
    binary_signature = @sender_priv_key.dsa_sign_asn1(transaction_object.to_s) # String Binary #:TODO: Hex?
  end
end