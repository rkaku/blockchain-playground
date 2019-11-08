RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN = 31, 32, 33, 34, 35, 36


def put_string(chain)
  chain.each.with_index(1) do |block, index|
    puts  ' '
    puts "\e[#{BLUE}m#{'=' * 41}" + " #{index} " + "#{'=' * 41}\e[0m"

    block.each do |key, value|

      if key.to_s == "transactions"
        printf("\e[#{MAGENTA}m%14s: \e[0m\n", key)

        value.each do |transanction|
          puts "\e[#{MAGENTA}m#{'- ' * 43}\e[0m"

          transanction.each do |tkey, tvalue|
            if tkey.to_s == "value"
              printf("%18s: %s\n", tkey, tvalue.to_f)
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