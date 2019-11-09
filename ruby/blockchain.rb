require 'json'
require 'openssl'
require 'bigdecimal'
require 'bigdecimal/util'
require_relative './helper.rb'
# require_relative './cipher.rb'


class Blockchain
  attr :transaction_pool, :chain, :blockchain_address

  def initialize(blockchain_address = nil)
    @transaction_pool = []
    @chain = []
    create_block(0, generate_hash({}))
    @blockchain_address = blockchain_address
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
    OpenSSL::Digest.new('sha256').update(json_block) # :TODO: OpenSSL::Digest::
  end

  def add_transaction(sender_address, recipient_address, value)
    transaction = {
      sender_address: sender_address,
      recipient_address: recipient_address,
      value: value.to_d.floor(8)
    }
    @transaction_pool.push(transaction)
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
    tmp = Marshal.dump(@transaction_pool)
    transactions = Marshal.load(tmp)
    previous_hash = generate_hash(@chain[-1])
    nonce = 0
    nonce += 1 while !valid_ploof(transactions, previous_hash, nonce)
    return nonce
  end

  def mining
    add_transaction(
      sender_address = BLOCKCHAIN_ADDRESS,
      recipient_address = @blockchain_address,
      value = REWARD
    )
    nonce = ploof_of_work
    previous_hash = generate_hash(chain[-1])
    create_block(nonce, previous_hash)
    puts 'action: MINING, status: SUCCESS'
    return true
  end

  def calculate_total_amount(my_blockchain_address)
    total_amount = '0.0'.to_d
    @chain.each do |block|
      block.each do |key, value|
        if key.to_s == 'transactions'
          value.each do |transaction|
            if transaction[:recipient_address] == my_blockchain_address
              total_amount += transaction[:value]
            elsif transaction[:sender_address] == my_blockchain_address
              total_amount -= transaction[:value]
            end
          end
        end
      end
    end
    return total_amount
  end
end


my_blockchain_address = 'my_blockchain_address'
blockchain = Blockchain.new(my_blockchain_address)
put_string(blockchain.chain)

blockchain.add_transaction('A', 'B', '50')
blockchain.mining
# previous_hash = blockchain.generate_hash(blockchain.chain[-1])
# nonce = blockchain.ploof_of_work
# blockchain.create_block(nonce, previous_hash)
put_string(blockchain.chain)

blockchain.add_transaction('C', 'D', '60')
blockchain.add_transaction('E', 'F', '70')
blockchain.mining
# previous_hash = blockchain.generate_hash(blockchain.chain[-1])
# nonce = blockchain.ploof_of_work
# blockchain.create_block(nonce, previous_hash)
put_string(blockchain.chain)
puts "my #{blockchain.calculate_total_amount(my_blockchain_address).to_f} #{UNIT}"
puts "C #{blockchain.calculate_total_amount('C').to_f} #{UNIT}"
puts "D #{blockchain.calculate_total_amount('D').to_f} #{UNIT}"