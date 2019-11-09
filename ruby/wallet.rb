require 'openssl'
require 'base58'


class Wallet
  VERSION_PREFIX = ['00'].pack('H2')

  def initialize
    @priv_key = generate_priv_key #<OpenSSL::PKey::EC:0x00007f80acb0d400>
    @pub_key = generate_pub_key(priv_key) #<OpenSSL::PKey::EC:0x00007f80acb0d180>
  end

  def generate_priv_key
    OpenSSL::PKey::EC.new('secp256k1').generate_key
  end

  def generate_pub_key(_priv_key)
    _pub_key = _priv_key.dup #<OpenSSL::PKey::EC:0x00007f80acb0d180>
  end

  def priv_key
    @priv_key.private_key.to_s(16)
  end

  def pub_key
    @pub_key.private_key.to_s(16)
  end

  def generate_address(_pub_key)
    _pub_key.private_key = nil
    binary_pub_key = _pub_key.to_der
    single_hashed_pub_key = OpenSSL::Digest::SHA256.digest(binary_pub_key)
    double_hashed_pub_key = OpenSSL::Digest::RIPEMD160.digest(single_hashed_pub_key)
    double_hashed_pub_key_with_version_prefix = double_hashed_pub_key.insert(0, VERSION_PREFIX)
    sha256_once = OpenSSL::Digest::SHA256.new.digest(double_hashed_pub_key_with_version_prefix)
    sha256_twice = OpenSSL::Digest::SHA256.new.digest(sha256_once)
    checksum = string_to_binary_4_digit(sha256_twice)
    binary_address = checksum + double_hashed_pub_key
    base58_address = Base58.binary_to_base58(binary_address, :bitcoin)
  end

  def string_to_binary_4_digit(str)
    str.unpack('H4').pack('H4')
  end
end