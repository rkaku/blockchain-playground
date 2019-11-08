RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN = 31, 32, 33, 34, 35, 36


def put_string(chains)
  puts  ' '
  chains.each.with_index(1) do |chain, index|
    puts "\e[#{BLUE}m#{'=' * 40}" + " #{index} " + "#{'=' * 40}\e[0m"

    chain.each do |key, value|

      if key.to_s == "transactions"
        printf("\e[#{MAGENTA}m%14s: \e[0m\n", key)

        value.each do |transanction|
          puts "\e[#{MAGENTA}m#{'- ' * 42}\e[0m"

          transanction.each do |tkey, tvalue|
            printf("%20s: %s\n", tkey, tvalue)
          end
        end
      else
        printf("%14s: %s\n", key, value)
      end
    end
  end
end


def sort_dict_by_key(unsorted_dict)
  unsorted_dict.sort.to_h
end