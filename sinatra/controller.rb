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
  headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Headers'] = 'accept, authorization, origin'
end

options '*' do
  response.headers['Allow'] = 'HEAD,GET,PUT,DELETE,OPTIONS,POST'
  response.headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept'
end

# Cache Instance
c = Cache.new

# GET => Wallet Data
# {
#   "sender_priv_key"=>"Lzhp9LopCFeWZzD4G5yJZ8c3mpB8ckymPdAxjFandtPXKJSG5stWoDiRKazCKVLexCA7uuzqnyiWZZkLcpMXoWvaevukB7ezqyDr772V5cafMmTcd6GcWAktKGZHVqWHJ41naTGnwPeiGHZ4uzDHVnWGv4b156Gor",
#   "sender_pub_key"=>"PZ8Tyr4Nx8MHsRAGMpZmZ6TWY63dXWSCzdutm7KuUpG1abEzKWegd6jyYRFjhFPsh1G7ShwQtdiJcbNNAPBcpMHZ7zASD8TnfEpcrRwcW66N9wauJaEyvaoA",
#   "sender_address"=>"2ArCaRj3jQGcPUWEUSJPcbgGSsiX96dVbQs",
#   "recipient_address"=>"fgrW7DVZ4qQmc7uy9amAQ6aYA9nFmze5Jo",
#   "value"=>"100"
# }
get '/wallet' do
  p c.get_wallet_cache.to_json
end

# POST => Send BTC
post '/send' do
  p json = JSON.parse(request.body.read)
  #                                       # alice_priv_key = json["sender_priv_key"]
  alice_pub_key = json["sender_pub_key"]
  alice_address = json["sender_address"]
                                          # BTC
                                          # Address => Restored Hashed Key
                                          # Restored Hashed Key == Hashed pub_key ? True : False
  bob_address = json["recipient_address"]
  value = json["value"].to_f

  ############## Client Side ############## Public Key, Signature, Transaction
  p tran = Transaction.new(
    c.alice.priv_key, # sender_priv_key => Signature
    alice_pub_key,
    alice_address,
    bob_address,
    value
  )
  binary_pub_key = c.alice.pub_key.to_der #OpenSSL ( Wallet => Binary pub_key.to_der => Blockchain )
  signature = tran.generate_signature
  p '/send #tran_obj', transaction_obj = tran.tran_obj
  ############## Client Side ##############

  p is_added = c.blockchain.add_transaction(
    alice_address,
    bob_address,
    value,
    # alice_pub_key, # String => OpenSSL::PKey::ECError
    binary_pub_key, # OpenSSL ( Wallet => Binary pub_key.to_der => Blockchain )
    signature,
    transaction_obj
  )
end

# GET => Transaction Pool Data
get '/pool' do
  p c.blockchain.transaction_pool.to_json
end

# GET => Mining
get '/mine' do
  if result = c.blockchain.mining
    puts "Mining: Success :)"
    result.to_json
  else
    puts "Mining: Failed :("
    result.to_json
  end
end

# GET => Blockchain Data
get '/chain' do
  p [
    c.blockchain.chain,
    c.blockchain.calculate_total_amount(c.alice.address),
    c.blockchain.calculate_total_amount(c.bob.address)
  ].to_json
end


helpers do
  def h(src)
    Rack::Utils.escape_html(src)
  end
end


# Elliptic curve Diffie-Hellman key exchange

# BTC
# Private Key => Signature, Public Key, Transaction
# Address => %1 Hashed Key
# Public Key => %2 Hashed Public Key
# %1 Hashed Key == %2 Hashed Public Key => Verified

# OpenSSL
# Binary Public Key => Public Key Object
# Pblic Key Object + OpenSSL + Data + Signature => Verified


# Transaction Data Verification

# BTC
# Previous Hash ??? => Verified ?

# OpenSSL
# Blockchain => add_transaction => ( sender_address, recipient_address, value ) => %1 transaction
# Signature => Transaction => ( sender_address, recipient_address, value ) => %2 tran_obj
# %1 transaction == %2 tran_obj => Verified