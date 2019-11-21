require 'json'
require 'openssl'

require_relative './helper.rb'


class Blockchain

  BLOCKCHAIN_PLAYGROUND_ADDRESS = 'BLOCKCHAIN PLAYGROUND'
  DIFFICULTY = 3
  REWARD = 1.0

  attr_reader :transaction_pool, :chain

  def initialize(miner_address)
  # def initialize(miner_address = nil)
    @transaction_pool = []
    @chain = []
    create_block(0, generate_hash({}))
    @miner_address = miner_address
  end

  def create_block(nonce, previous_hash)
    block = sort_dict_by_key({
      timestamp: Time.now,
      transactions: @transaction_pool,
      nonce: nonce,
      previous_hash: previous_hash
    })
    @chain << block
    @transaction_pool = []
    return block
  end

  def generate_hash(block)
    sorted_block = sort_dict_by_key(block)
    json_block = sorted_block.to_json
    OpenSSL::Digest::SHA256.hexdigest(json_block)
  end

  def add_transaction(sender_address, recipient_address, value, sender_pub_key = nil, signature = nil, tran_obj = nil)
    # Miner or Wallet Transaction => transaction
    p 'Miner or Wallet Transaction', transaction = sort_dict_by_key({
      sender_address: sender_address,
      recipient_address: recipient_address,
      value: value
    })
    # Wallet Transaction => tran_obj
    p 'Wallet Transaction Object', tran_obj
    p 'Wallet Transaction Reverse Bool', !tran_obj
    # Transaction Pool => @transaction_pool
    p 'Transaction Pool', @transaction_pool
    p 'Transaction Pool Reverse Bool', @transaction_pool.empty?
    if sender_address.to_s == BLOCKCHAIN_PLAYGROUND_ADDRESS
      if @transaction_pool.empty?
        false
      else
        @transaction_pool << transaction
        true
      end
    else
      if verify_transaction_signature(sender_pub_key, transaction, signature) && verify_transaction(transaction, tran_obj)

        ########## No Coin Error ##########
        # if calculate_total_amount(sender_address) < value
        #   false
        # else
        #   @transaction_pool << transaction
        #   true
        # end
        ########## No Coin Error ##########

        @transaction_pool << transaction
        true
      else
        false
      end
    end
  end

  def verify_transaction_signature(sender_pub_key, transaction, signature)
    sender_pub_key_obj = OpenSSL::PKey::EC.new(sender_pub_key)
    sender_pub_key_obj.dsa_verify_asn1(transaction.to_s, signature)

    # Error
    # sender_pub_key.dsa_verify_asn1(transaction.to_s, signature)
  end

  def verify_transaction(transaction, tran_obj)
    transaction == tran_obj
  end

  # Nonce => PoW => Mining
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
    # Deep Copy => Transactions
    tmp = Marshal.dump(@transaction_pool)
    transactions = Marshal.load(tmp)
    # Crerate Previous Hash
    previous_hash = generate_hash(@chain[-1])
    # Create Nonce
    nonce = 0
    nonce += 1 while !valid_ploof(transactions, previous_hash, nonce)
    nonce
  end

  def mining
    if add_transaction(
      sender_address = BLOCKCHAIN_PLAYGROUND_ADDRESS,
      recipient_address = @miner_address,
      value = REWARD
      )
      nonce = ploof_of_work
      previous_hash = generate_hash(chain[-1])
      create_block(nonce, previous_hash)
      puts 'action: MINING, status: SUCCESS'
      true
    else
      puts 'action: MINING, status: FAILED'
      false
    end
  end

  def calculate_total_amount(my_blockchain_address)
    total_amount = 0
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
    total_amount.to_f
  end
end