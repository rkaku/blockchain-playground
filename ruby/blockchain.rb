require 'json'
require 'openssl'
require 'bigdecimal'
require 'bigdecimal/util'
require_relative './helper.rb'
require_relative './cipher.rb'


DIFFICULTY = 3


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

  def valid_ploof(transactions, previous_hash, nonce, difficulty = DIFFICULTY)
    next_block = sort_dict_by_key({
      transactions: transactions,
      previous_hash: previous_hash,
      nonce: nonce
    })
    next_hash = generate_hash(next_block)
    return next_hash.to_s.slice(0..2) == '0' * difficulty
  end

  def ploof_of_work
    tmp = Marshal.dump(transaction_pool)
    transactions = Marshal.load(tmp)
    previous_hash = generate_hash(chain[-1])
    nonce = 0
    while !valid_ploof(transactions, previous_hash, nonce)
      nonce += 1
    end
    return nonce
  end
end


blockchain = Blockchain.new()
put_string(blockchain.chain)

blockchain.add_transaction('A', 'B', '50')
previous_hash = blockchain.generate_hash(blockchain.chain[-1])
nonce = blockchain.ploof_of_work
blockchain.create_block(nonce, previous_hash)
put_string(blockchain.chain)

blockchain.add_transaction('C', 'D', '60')
blockchain.add_transaction('E', 'F', '70')
previous_hash = blockchain.generate_hash(blockchain.chain[-1])
nonce = blockchain.ploof_of_work
blockchain.create_block(nonce, previous_hash)
put_string(blockchain.chain)