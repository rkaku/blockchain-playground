require 'base58'
require 'openssl'

require_relative './helper.rb'


class Transaction

  def initialize(sender_priv_key, sender_pub_key, sender_address, recipient_address, value)
    @sender_priv_key = sender_priv_key
    @sender_pub_key = sender_pub_key
    @sender_address = sender_address
    @recipient_address = recipient_address
    @value = value
  end

  # Transaction for Signature
  def transaction_object
    transaction = sort_dict_by_key({
      sender_address: @sender_address,
      recipient_address: @recipient_address,
      value: @value
    })
  end

  # Transaction for Signature Verification
  def tran_obj
    transaction_object
  end

  def generate_signature
    binary_signature = @sender_priv_key.dsa_sign_asn1(transaction_object.to_s) # String Binary

    # Error
    # Client => @sender_priv_key => String Hex
    # p sender_priv_key_obj = OpenSSL::PKey::EC.new(@sender_priv_key)
  end
end