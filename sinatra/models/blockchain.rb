require 'json'
require 'openssl'
# require 'bigdecimal'
# require 'bigdecimal/util'
require_relative './helper.rb'


class Blockchain

  # attr_accessor :transaction_pool, :chain, :blockchain_address

  def initialize(blockchain_address = nil)
    @transaction_pool = []
    @chain = []
    create_block(0, generate_hash({}))
    @blockchain_address = blockchain_address
  end

  def create_block(nonce, previous_hash)
    block = sort_dict_by_key({
      timestamp: Time.now,
      transactions: @transaction_pool,
      nonce: nonce,
      previous_hash: previous_hash
    })
    @chain.push(block)
    @transaction_pool = []
    return block
  end

  def generate_hash(block)
    sorted_block = sort_dict_by_key(block)
    json_block = JSON.fast_generate(sorted_block) #:FIXME: .to_json
    OpenSSL::Digest::SHA256.hexdigest(json_block)
  end

  def add_transaction(sender_address, recipient_address, value, sender_pubkey = nil, signature = nil, tran_obj = nil)
    # p value
    transaction = sort_dict_by_key({
      sender_address: sender_address,
      recipient_address: recipient_address,
      value: value
      # value: value.to_d.floor(8)
    })
    if sender_address.to_s == BLOCKCHAIN_ADDRESS
      @transaction_pool.push(transaction)
      return true
    elsif verify_transaction_signature(sender_pubkey, transaction, signature) && verify_transaction(transaction, tran_obj)
      # if calculate_total_amount(sender_address) < value :FIXME: No Coin Error
      #   false
      # else
      #   @transaction_pool.push(transaction)
      #   return true
      # end
      @transaction_pool.push(transaction)
      return true
    else
      return false
    end
  end

  def verify_transaction_signature(sender_pubkey, transaction, signature)
    sender_pubkey.dsa_verify_asn1(transaction.to_s, signature)
  end

  def verify_transaction(transaction, tran_obj)
    transaction == tran_obj
  end

  def valid_ploof(transactions, previous_hash, nonce, difficulty = DIFFICULTY)
    next_block = sort_dict_by_key({
      transactions: transactions,
      previous_hash: previous_hash,
      nonce: nonce
    })
    next_hash = generate_hash(next_block)
    next_hash.to_s.slice(0..2) == '0' * difficulty
  end

  def ploof_of_work
    tmp = Marshal.dump(@transaction_pool)
    transactions = Marshal.load(tmp)
    previous_hash = generate_hash(@chain[-1])
    nonce = 0
    nonce += 1 while !valid_ploof(transactions, previous_hash, nonce)
    nonce
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
    total_amount = 0
    # total_amount = '0.0'.to_d
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
    total_amount.to_f #:FIXME: bigdecimal
  end

  def chain
    @chain
  end

  def transaction_pool
    @transaction_pool
  end
end