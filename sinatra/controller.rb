require 'sinatra'
require 'sinatra/reloader'
require 'openssl'
require 'base58'
require 'json'
require './models/wallet.rb'
require './models/blockchain.rb'
require './models/transaction.rb'


# cache = {}
# alice = Wallet.new
# bob = Wallet.new
# tran = Transaction.new(alice.priv_key, alice.pub_key, alice.address, bob.address, 100)
# miner = Wallet.new
# blockchain = Blockchain.new(miner.address)

class Cache
  attr_reader :alice, :bob, :miner, :blockchain

  def initialize
    @alice = Wallet.new
    @bob = Wallet.new
    @miner = Wallet.new
    @blockchain = Blockchain.new(@miner.address)
  end

  def get_wallet_cache
    p [@alice.get_wallet, @bob.get_wallet]
  end
end


  # is_added = blockchain.add_transaction(alice.address, bob.address, 80, alice.pub_key, tran.generate_signature, tran.tran_obj)
  # blockchain.mining

c = Cache.new

get '/wallet' do
  p c.get_wallet_cache.to_json
end

post '/send' do
# post '/send', provides: :json do
  p JSON.parse(request.body.read) #:TODO:
  # p tran = Transaction.new(alice.priv_key, alice.pub_key, alice.address, bob.address, 100)
  # p is_added = blockchain.add_transaction(alice.address, bob.address, 100, alice.pub_key, tran.generate_signature, tran.tran_obj)
end

get '/pool' do
  p tran = Transaction.new(
    c.alice.priv_key,
    c.alice.pub_key,
    c.alice.address,
    c.bob.address,
    100
  )
  p is_added = c.blockchain.add_transaction(
    c.alice.address,
    c.bob.address,
    100,
    c.alice.pub_key,
    tran.generate_signature,
    tran.tran_obj
  )
  c.blockchain.transaction_pool.to_json
end

get '/mine' do
# post '/mine', provides: :json do
  # p JSON.parse(request.body.read)
  # p 'Is added?', is_added
  p c.blockchain.mining
  "Success :)"
end

get '/chain' do
  p [
    c.blockchain.chain,
    c.blockchain.calculate_total_amount(c.alice.address),
    c.blockchain.calculate_total_amount(c.bob.address)
  ].to_json
end


helpers do
  def escape_html(src)
    Rack::Utils.escape_html(src)
  end
end