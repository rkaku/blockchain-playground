RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN = 31, 32, 33, 34, 35, 36

def put_string(chains)

  chains.each.with_index(1) do |chain, index|
    puts "\e[#{BLUE}m#{'=' * 40}" + " #{index} " + "#{'=' * 40}\e[0m"

    chain.each do |key, value|
      printf("%14s: %s\n", key, value)
    end
  end
end

def sort_dict_by_key(unsorted_dict)
  unsorted_dict.sort.to_h
end