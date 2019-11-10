require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'openssl'
require 'base58'


get '/' do
  'Hello, Blockchain!!'
end

# get '/wallet' do
#   hash = JSON.generate(alice)
# end

get '/hello/*' do |name|
  "Hello, #{name}."
end

get '/erb_template_page' do
  erb :erb_template_page
end

get '/std/:arg' do
  "display args #{params[:arg]}"
end

class Wallet
  VERSION_PREFIX = ['00'].pack('H2')

  def initialize
    @priv_key = generate_priv_key #<OpenSSL::PKey::EC:0x00007f80acb0d400>
    @pub_key = generate_pub_key(@priv_key) #<OpenSSL::PKey::EC:0x00007f80acb0d180>
    @address = generate_address(@pub_key)
  end

  def generate_priv_key
    OpenSSL::PKey::EC.new('secp256k1').generate_key
  end

  def generate_pub_key(priv_key)
    pub_key = OpenSSL::PKey::EC.new(priv_key)
    pub_key.private_key = nil
    pub_key
  end

  def priv_key
    # @priv_key #<OpenSSL::PKey::EC:0x00007f80acb0d400>
    if @priv_key.private_key?
      # @priv_key.private_key #37109748745563250911720757976095590944029692158261137885083756599577546442030
      @priv_key #<OpenSSL::PKey::EC:0x00007f80acb0d400>
    end
  end

  def pub_key
    # @pub_key #<OpenSSL::PKey::EC:0x00007f80acb0d180>
    if @pub_key.public_key?
      # @pub_key.public_key #<OpenSSL::PKey::EC::Point:0x00007fa9429b0b48>
      @pub_key #<OpenSSL::PKey::EC::Point:0x00007fa9429b0b48>
    end
  end

  def address
    @address
  end

  def generate_address(pub_key)
    binary_pub_key = pub_key.to_der
    single_hashed_pub_key = OpenSSL::Digest::SHA256.hexdigest(binary_pub_key)
    double_hashed_pub_key = OpenSSL::Digest::RIPEMD160.hexdigest(single_hashed_pub_key)
    double_hashed_pub_key_with_version_prefix = double_hashed_pub_key.insert(0, VERSION_PREFIX)
    sha256_once = OpenSSL::Digest::SHA256.hexdigest(double_hashed_pub_key_with_version_prefix)
    sha256_twice = OpenSSL::Digest::SHA256.hexdigest(sha256_once)
    checksum = sha256_twice[0..7]
    hex_address = checksum + double_hashed_pub_key
    binary_address = [hex_address].pack('H*')
    base58_address = Base58.binary_to_base58(binary_address, :bitcoin)
  end
end

alice = Wallet.new

obj = {
  priv_key: Base58.binary_to_base58(alice.priv_key.to_der, :bitcoin),
  pub_key: Base58.binary_to_base58(alice.pub_key.to_der, :bitcoin),
  address: alice.address
}

get '/wallet' do
  hash = JSON.generate(obj)
end