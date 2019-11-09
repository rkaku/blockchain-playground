require 'openssl'
require 'base58'
# require_relative './helper.rb'


block = { 'a': 1, 'b': 2 }

def sort_dict_by_key(unsorted_dict)
  unsorted_dict.sort.to_h
end

p OpenSSL::Digest.new('sha256').update(sort_dict_by_key(block).to_s).to_s.slice(0..2)


VERSION_PREFIX = ['00'].pack('H2')

# def string_to_binary_4_bytes(str)
#   # str.unpack('H16').pack('H16')
#   str[0..7]
# end

ec_priv_key = OpenSSL::PKey::EC.new('secp256k1').generate_key
puts "#{'- ' * 40}"
puts 'ec_priv_key', ec_priv_key #<OpenSSL::PKey::EC:0x00007fe23d138ea0>
# puts 'ec_pub_key_before_nil dup', ec_pub_key = ec_priv_key.dup #<OpenSSL::PKey::EC:0x00007f80acb0d180>
puts 'ec_pub_key_before_nil OpenSSL', ec_pub_key = OpenSSL::PKey::EC.new(ec_priv_key) #<OpenSSL::PKey::EC:0x00007fe23d138c70>
puts "#{'- ' * 40}"
puts 'ec_pub_key#private_key', ec_pub_key.private_key #17064189403599313817000748531393122595498886288457030985270711779445612364706
puts 'ec_pub_key#public_key', ec_pub_key.public_key #<OpenSSL::PKey::EC::Point:0x00007f8d9aa00ad0>
puts 'nil', ec_pub_key.private_key = nil
puts 'ec_pub_key#private_key', ec_pub_key.private_key #
puts 'ec_pub_key#public_key', ec_pub_key.public_key #<OpenSSL::PKey::EC::Point:0x00007fa9429b0b48>
puts "#{'- ' * 40}"
puts 'ec_pub_key_after_nil', ec_pub_key #<OpenSSL::PKey::EC:0x00007f80acb0d180>
# puts 'text_pub_key', text_pub_key = ec_pub_key.to_text
p 'binary_pub_key', binary_pub_key = ec_pub_key.to_der
puts "#{'- ' * 40}"
puts 'SHA256', single_hashed_pub_key = binary_to_sha256 = OpenSSL::Digest::SHA256.hexdigest(binary_pub_key)
puts 'ripedmd160', double_hashed_pub_key = sha256_to_ripedmd160 = OpenSSL::Digest::RIPEMD160.hexdigest(single_hashed_pub_key)
puts "#{'- ' * 40}"
puts 'version_prefix', version_prefix = VERSION_PREFIX
puts 'addnl_hash_for_checksum', addnl_hash_for_checksum = double_hashed_pub_key_with_version_prefix = double_hashed_pub_key.insert(0, version_prefix)
puts "#{'- ' * 40}"
puts 'sha256_for_checksum_once', sha256_for_checksum_once = OpenSSL::Digest::SHA256.hexdigest(addnl_hash_for_checksum)
# puts 'sha256_for_checksum_once', sha256_for_checksum_once = OpenSSL::Digest::SHA256.new.hexdigest(addnl_hash_for_checksum)
p 'sha256_for_checksum_twice', sha256_for_checksum_twice = OpenSSL::Digest::SHA256.hexdigest(sha256_for_checksum_once)
# puts 'sha256_for_checksum_twice', sha256_for_checksum_twice = OpenSSL::Digest::SHA256.new.hexdigest(sha256_for_checksum_once)
puts "#{'- ' * 40}"
p 'checksum', checksum = sha256_for_checksum_twice[0..7]
# p 'checksum', checksum = string_to_binary_4_bytes(sha256_for_checksum_twice)
puts 'hex_address', hex_address = checksum + double_hashed_pub_key
puts 'binary_address', binary_address = [hex_address].pack('H*')
# puts 'int_address', int_address = hex_address.hex
# puts 'binary_address', binary_address = checksum + double_hashed_pub_key
puts "#{'- ' * 40}"
puts 'base58_address', btc_address = base58_address = Base58.binary_to_base58(binary_address, :bitcoin)
# puts 'base58_address', btc_address = base58_address = Base58.binary_to_base58(int_address, :bitcoin)
puts "Yay, You,re on Blockchain!", btc_address #4bABCpEzWBFUP9LpafTMnSxPWbjpT5oZ
puts "#{'- ' * 40}"


# 公開鍵 => 楕円直線上の点を表すオブジェクト
puts 'ec_key#public_key', ec_key = ec_priv_key.public_key #<OpenSSL::PKey::EC::Point:0x00007fa139805ac0>
puts 'enum_ec_key#public_key#to_enum', enum_ec_key = ec_priv_key.public_key.to_enum #<Enumerator:0x00007fa139805930>


puts 'ec_priv_key', ec_priv_key #<OpenSSL::PKey::EC:0x00007f80acb0d400>
# puts 'ec_priv_key#private_key', ec_priv_key.private_key #15572663481549176295171727004540230550386809360413722713884717848274798810783
# puts 'ec_priv_key#private_key#to_s(16)', ec_priv_key.private_key.to_s(16) #9D067EB224810DD9FACD2D406597314761F4C24D7F5548E0126F217205FF97E9


# :TODO:
# OpenSSL::Random 乱数初期化