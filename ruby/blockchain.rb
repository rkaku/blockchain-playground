require 'json'
require 'openssl'
require 'bigdecimal'
require 'bigdecimal/util'
require_relative './helper.rb'
require_relative './cipher.rb'


class Blockchain

  attr :transaction_pool, :chain

  def initialize
    @transaction_pool = []
    @chain = []
    create_block(0, generate_hash({}))
  end

  def create_block(nonce, previous_hash)
    block = {
      timestamp: Time.now,
      transactions: @transaction_pool,
      nonce: nonce,
      previous_hash: previous_hash
    }

    # block.update({
    #   timestamp: Time.now,
    #   transactions: @transaction_pool,
    #   nonce: nonce,
    #   previous_hash: previous_hash
    # })

    # block = {
    #   timestamp: Time.now,
    #   transactions: @transaction_pool
    # }
    # block[:nonce] = nonce
    # block[:previous_hash] = previous_hash

    block = sort_dict_by_key(block)
    @chain.push(block)
    @transaction_pool = []
    return block
  end

  def generate_hash(block)
    sorted_block = sort_dict_by_key(block)
    json_block = JSON.fast_generate(sorted_block)
    OpenSSL::Digest.new('sha256').update(json_block)
  end

  def add_transaction(sender_address, recipient_address, value)
    transaction = {
      sender_address: sender_address,
      recipient_address: recipient_address,
      value: value.to_d.floor(8)
    }
    transaction_pool.push(transaction)
    return true
  end
end


blockchain = Blockchain.new()
put_string(blockchain.chain)

blockchain.add_transaction('A', 'B', '50')
previous_hash = blockchain.generate_hash(blockchain.chain[-1])
blockchain.create_block(5, previous_hash)
put_string(blockchain.chain)

blockchain.add_transaction('C', 'D', '60')
blockchain.add_transaction('E', 'F', '70')
previous_hash = blockchain.generate_hash(blockchain.chain[-1])
blockchain.create_block(6, previous_hash)
put_string(blockchain.chain)