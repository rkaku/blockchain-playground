require 'sinatra'
require 'sinatra/reloader'
require 'openssl'
require 'base58'
require 'json'
require './models/wallet.rb'
require './models/blockchain.rb'
require './models/transaction.rb'

  alice = Wallet.new
  bob = Wallet.new
  tran = Transaction.new(alice.priv_key, alice.pub_key, alice.address, bob.address, 100)

  miner = Wallet.new
  blockchain = Blockchain.new(miner.address)

  # is_added = blockchain.add_transaction(alice.address, bob.address, 80, alice.pub_key, tran.generate_signature, tran.tran_obj)
  # blockchain.mining

get '/wallet' do
  # alice = Wallet.new
  # bob = Wallet.new
  status 200
  body [alice.get_wallet, bob.get_wallet].to_json
  # body alice.get_wallet
end

post '/send' do
  tran = Transaction.new(alice.priv_key, alice.pub_key, alice.address, bob.address, 100)
end

get '/pool' do
  # tran = Transaction.new(alice.priv_key, alice.pub_key, alice.address, bob.address, 100)

  # miner = Wallet.new
  # blockchain = Blockchain.new(miner.address)
  status 200
  body blockchain.transaction_pool.to_json
end

post '/mine' do
  is_added = blockchain.add_transaction(alice.address, bob.address, 80, alice.pub_key, tran.generate_signature, tran.tran_obj)
  # p 'Is added?', is_added
  blockchain.mining
end

get '/chain' do
  is_added = blockchain.add_transaction(alice.address, bob.address, 80, alice.pub_key, tran.generate_signature, tran.tran_obj)
  blockchain.mining

  status 200
  body [
    blockchain.chain,
    blockchain.calculate_total_amount(alice.address),
    blockchain.calculate_total_amount(bob.address)
  ].to_json
end

# get '/amount' do
#   blockchain.calculate_total_amount(alice.address)
#   blockchain.calculate_total_amount(bob.address)
# end

