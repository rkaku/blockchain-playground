UNIT = 'BTC'
# DIFFICULTY = 3
# REWARD = 1.0
# BLOCKCHAIN_ADDRESS = 'BLOCKCHAIN PLAYGROUND' #:TODO:
RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN = 31, 32, 33, 34, 35, 36


# Terminal Standard Output
def put_string(chain)
  chain.each.with_index(1) do |block, index|
    puts ' '
    puts "\e[#{BLUE}m#{'=' * 41}" + " #{index} " + "#{'=' * 41}\e[0m"

    block.each do |key, value|
      if key.to_s == 'transactions'
        printf("\e[#{MAGENTA}m%14s: \e[0m\n", key)

        value.each do |transanction|
          puts "\e[#{MAGENTA}m#{'- ' * 43}\e[0m"

          transanction.each do |tkey, tvalue|
            if tkey.to_s == 'value'
              printf("%18s: %s %s\n", tkey, tvalue.to_f, UNIT)
            else
              printf("%18s: %s\n", tkey, tvalue)
            end
          end
        end
      else
        printf("%14s: %s\n", key, value)
      end
    end
  end
  puts "\e[#{GREEN}m#{'__' * 43}\e[0m\n"
end

def sort_dict_by_key(unsorted_dict)
  unsorted_dict.sort.to_h
end

# p unsorted_dict.sort
# [
#   [:nonce, 0],
#   [:previous_hash, "4f53cda18c2baa0c0354bb5f9a3ecbe5ed12ab4d8e11ba873c2f11161202b945"],
#   [:timestamp, 2019-11-20 17:01:38 +0900],
#   [:transactions, []]
# ]

# p unsorted_dict.sort.to_h
# {
#   :nonce=>0,
#   :previous_hash=>"44136fa355b3678a1146ad16f7e8649e94fb4fc21fe77e8310c060f61caaff8a",
#   :timestamp=>2019-11-20 17:03:07 +0900,
#   :transactions=>[]
# }