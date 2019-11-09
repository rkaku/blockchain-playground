require 'openssl'
require 'base58'


class Wallet
end


VERSION_PREFIX = ['00'].pack('H2')

def string_to_binary_4_digit(str)
  str.unpack('H4').pack('H4')
end

ec_priv_key = OpenSSL::PKey::EC.new('secp256k1').generate_key
puts "#{'- ' * 40}"
puts 'ec_priv_key', ec_priv_key
puts 'ec_pub_key_before_nil', ec_pub_key = ec_priv_key.dup
puts "#{'- ' * 40}"
puts 'ec_pub_key#private_key', ec_pub_key.private_key
puts 'nil', ec_pub_key.private_key = nil
puts 'ec_pub_key#private_key', ec_pub_key.private_key
puts "#{'- ' * 40}"
puts 'ec_pub_key_after_nil', ec_pub_key
puts 'binary_pub_key', binary_pub_key = ec_pub_key.to_der
puts "#{'- ' * 40}"
puts 'SHA256', single_hashed_pubkey = binary_to_sha256 = OpenSSL::Digest::SHA256.digest(binary_pub_key)
puts 'ripedmd160', double_hashed_pub_key = sha256_to_ripedmd160 = OpenSSL::Digest::RIPEMD160.digest(single_hashed_pubkey)
puts "#{'- ' * 40}"
puts 'version_prefix', version_prefix = VERSION_PREFIX
puts 'addnl_hash_for_checksum', addnl_hash_for_checksum = double_hashed_pub_key_with_version_prefix = double_hashed_pub_key.insert(0, version_prefix)
puts "#{'- ' * 40}"
puts 'sha256_for_checksum_once', sha256_for_checksum_once = OpenSSL::Digest::SHA256.new.digest(addnl_hash_for_checksum)
puts 'sha256_for_checksum_twice', sha256_for_checksum_twice = OpenSSL::Digest::SHA256.new.digest(sha256_for_checksum_once)
puts "#{'- ' * 40}"
puts 'checksum', checksum = string_to_binary_4_digit(sha256_for_checksum_twice)
puts 'binary_address', binary_address = checksum + double_hashed_pub_key
puts "#{'- ' * 40}"
puts 'base58_address', btc_address = base58_address = Base58.binary_to_base58(binary_address, :bitcoin)
puts "Yay, You,re on Blockchain!", btc_address
puts "#{'- ' * 40}"


# puts 'ec_pub_key', ec_pub_key = ec_priv_key.public_key
# puts 'ec_pub_key', binary_ec_pub_key = ec_priv_key.public_key.to_enum