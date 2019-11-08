require 'openssl'
require_relative './helper.rb'


block = {'a': 1, 'b': 2}

puts OpenSSL::Digest.new('sha256').update(sort_dict_by_key(block).to_s)