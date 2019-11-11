require 'sinatra'
require 'sinatra/reloader'
require 'openssl'
require 'base58'
require 'json'
require './models/wallet.rb'
require './models/blockchain.rb'
require './models/transaction.rb'


cache = {}
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
  # content_type :json
  body [alice.get_wallet, bob.get_wallet].to_json
  # body alice.get_wallet
end

post '/send' do
# post '/send', provides: :json do
  p JSON.parse(request.body.read)
  tran = Transaction.new(alice.priv_key, alice.pub_key, alice.address, bob.address, 100)
  p is_added = blockchain.add_transaction(alice.address, bob.address, 100, alice.pub_key, tran.generate_signature, tran.tran_obj)
end

get '/pool' do
  # tran = Transaction.new(alice.priv_key, alice.pub_key, alice.address, bob.address, 100)

  # miner = Wallet.new
  # blockchain = Blockchain.new(miner.address)
  # content_type :json
  body blockchain.transaction_pool.to_json
end

post '/mine', provides: :json do
  p JSON.parse(request.body.read)
  # p 'Is added?', is_added
  blockchain.mining
end

get '/chain' do
  # is_added = blockchain.add_transaction(alice.address, bob.address, 80, alice.pub_key, tran.generate_signature, tran.tran_obj)
  # blockchain.mining

  # content_type :json
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

helpers do
  def escape_html(text)
    Rack::Utils.escape_html(text)
  end
end