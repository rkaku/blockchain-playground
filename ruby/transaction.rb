require 'json'
require 'openssl'
require 'base58'
require_relative './helper.rb'


class Transaction

  def initialize(sender_priv_key, sender_pub_key, sender_address, recipient_address, value)
    @sender_priv_key = sender_priv_key
    @sender_pub_key = sender_pub_key
    @sender_address = sender_address
    @recipient_address = recipient_address
    @value = value
  end

  def generate_signature
    transaction = sort_dict_by_key({
      sender_address: @sender_address,
      recipient_address: @recipient_address,
      value: @value
    })
    # json_transaction = JSON.fast_generate(transaction)
    # trarnsaction_data = OpenSSL::Digest::SHA256.hexdigest(json_transaction)
    trarnsaction_data = OpenSSL::Digest::SHA256.hexdigest(transaction.to_s)
    binary_signature = @sender_priv_key.dsa_sign_asn1(trarnsaction_data) # String Binary #:TODO: Hex?
    hex_signature = binary_signature.unpack('H*')[0] # String Hex
  end
end