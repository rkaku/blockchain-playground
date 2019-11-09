require 'openssl'
require 'base58'
require_relative './transaction.rb'
require_relative './blockchain.rb'
require_relative './helper.rb'


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


# v2.0
miner = Wallet.new()
alice = Wallet.new()
bob = Wallet.new()
# sender_priv_key, sender_pub_key, sender_address, recipient_address, value
tran = Transaction.new(alice.priv_key, alice.pub_key, alice.address, bob.address, 80)


# REST
  # def initialize(blockchain_address = nil)
  #   @transaction_pool = []
  #   @chain = []
  #   create_block(0, generate_hash({}))
  #   @blockchain_address = blockchain_address
blockchain = Blockchain.new(miner.address)
  # def add_transaction(sender_address, recipient_address, value, sender_pubkey = nil, signature = nil)
  #  def add_transaction(sender_address, recipient_address, value, sender_pubkey = nil, signature = nil, tran_obj = nil)
is_added = blockchain.add_transaction(alice.address, bob.address, 80, alice.pub_key, tran.generate_signature, tran.tran_obj)
p 'Is added?', is_added
blockchain.mining
put_string(blockchain.chain)
p 'Alice', blockchain.calculate_total_amount(alice.address)
p 'Bob', blockchain.calculate_total_amount(bob.address)


























# v1.0
# wallet = Wallet.new
# p 'priv_key', priv_key = wallet.priv_key
# p 'pub_key', pub_key = wallet.pub_key
# p 'address', my_address = wallet.address

# tran = Transaction.new(priv_key, pub_key, my_address, 'Satoshi', '100')
# p 'signature', tran.generate_signature