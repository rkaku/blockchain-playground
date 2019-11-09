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

  def generate_pub_key(priv_key)
    pub_key = OpenSSL::PKey::EC.new(priv_key)
  end

  def priv_key
    # @priv_key #<OpenSSL::PKey::EC:0x00007f80acb0d400>
    if @priv_key.private_key?
      @priv_key.private_key #37109748745563250911720757976095590944029692158261137885083756599577546442030
    end
  end

  def pub_key
    # @pub_key #<OpenSSL::PKey::EC:0x00007f80acb0d180>
    if @pub_key.public_key?
      @pub_key.pub_key #<OpenSSL::PKey::EC::Point:0x00007fa9429b0b48>
    end
  end

  def generate_address(_pub_key)
    _pub_key.private_key = nil
    binary_pub_key = _pub_key.to_der
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


# :TODO: SHA256
# OpenSSL::Digest::SHA256.digest()
# OpenSSL::Digest::SHA256.new.digest()
# OpenSSL::Digest.new('sha256').update()