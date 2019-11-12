require 'sinatra'
require 'sinatra/reloader'
require 'openssl'
require 'base58'
require 'json'

require './models/blockchain.rb'
require './models/cache.rb'
require './models/transaction.rb'
require './models/wallet.rb'


before do
  response.headers['Access-Control-Allow-Origin'] = '*'
end

c = Cache.new

get '/wallet' do
  c.get_wallet_cache.to_json
end

# {
#   "sender_priv_key"=>"Lzhp9LopCFeWZzD4G5yJZ8c3mpB8ckymPdAxjFandtPXKJSG5stWoDiRKazCKVLexCA7uuzqnyiWZZkLcpMXoWvaevukB7ezqyDr772V5cafMmTcd6GcWAktKGZHVqWHJ41naTGnwPeiGHZ4uzDHVnWGv4b156Gor",
#   "sender_pub_key"=>"PZ8Tyr4Nx8MHsRAGMpZmZ6TWY63dXWSCzdutm7KuUpG1abEzKWegd6jyYRFjhFPsh1G7ShwQtdiJcbNNAPBcpMHZ7zASD8TnfEpcrRwcW66N9wauJaEyvaoA",
#   "sender_address"=>"2ArCaRj3jQGcPUWEUSJPcbgGSsiX96dVbQs",
#   "recipient_address"=>"fgrW7DVZ4qQmc7uy9amAQ6aYA9nFmze5Jo",
#   "value"=>"600"
# }

post '/send' do
# post '/send', provides: :json do
  json = JSON.parse(request.body.read)
  # alice_priv_key = json["sender_priv_key"]
  alice_pub_key = json["sender_pub_key"]
  alice_address = json["sender_address"] # Address => Hashed Key == Hashed pub_key ? True : False
  bob_address = json["recipient_address"]
  value = json["value"].to_f

  ############## Client Side ############## Public Key, Signature, Transaction
  p tran = Transaction.new(
    c.alice.priv_key, # => Signature
    alice_pub_key,
    alice_address,
    bob_address,
    value #:TODO: Class
  )
  binary_pub_key = c.alice.pub_key.to_der #:FIXME: Wallet => Binary pub_key.to_der => Blockchain
  signature = tran.generate_signature
  transaction_obj = tran.tran_obj
  ############## Client Side ##############

  p is_added = c.blockchain.add_transaction(
    alice_address,
    bob_address,
    value,
    # alice_pub_key, # String => OpenSSL::PKey::ECError
    binary_pub_key, # Wallet => Binary pub_key.to_der =>
    # c.alice.pub_key.to_der,
    signature,
    transaction_obj
    # tran.generate_signature,
    # tran.tran_obj
  )
end

get '/pool' do
  # p tran = Transaction.new(
  #   c.alice.priv_key,
  #   c.alice.pub_key,
  #   c.alice.address,
  #   c.bob.address,
  #   100
  # )
  # p is_added = c.blockchain.add_transaction(
  #   c.alice.address,
  #   c.bob.address,
  #   100,
  #   c.alice.pub_key,
  #   tran.generate_signature,
  #   tran.tran_obj
  # )
  c.blockchain.transaction_pool.to_json
end

get '/mine' do
# post '/mine', provides: :json do # ???
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


# Elliptic curve Diffie-Hellman key exchange

# BTC
# Private Key => Signature, Public Key, Transaction
# Address => Hash Key
# Public Key => Hashed Public Key
# Hash Key == Hashed Public Key => Verified

# SSL
# Binary Public Key => Public Key Object
# Pblic Key Object + SSL + Data + Signature => Verified

# Transaction Data Verification
# Previous Hash ???