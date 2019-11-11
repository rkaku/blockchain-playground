require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'openssl'
require 'base58'
require './models/wallet.rb'


alice = Wallet.new
obj = {
  priv_key: Base58.binary_to_base58(alice.priv_key.to_der, :bitcoin),
  pub_key: Base58.binary_to_base58(alice.pub_key.to_der, :bitcoin),
  address: alice.address
}

get '/wallet' do
  status 200
  body obj.to_json
end

get '/' do
  'Hello, Blockchain!!'
end