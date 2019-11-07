class Blockchain

  attr :transaction_pool, :chain

  def initialize
    @transaction_pool = []
    @chain = []
    create_block(0, 'hash 1')
  end

  def create_block(nonce, previous_hash)
    block = {
      timestamp: Time.now,
      transactions: @transaction_pool
    }
    block[:nonce] = nonce
    block[:previous_hash] = previous_hash
    @chain.push(block)
    @transaction_pool = []
    return block
  end
end

RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN = 31, 32, 33, 34, 35, 36

def put_string(chains)

  chains.each.with_index(1) do |chain, index|
    puts "\e[#{BLUE}m#{'=' * 35}" + " #{index} " + "#{'=' * 35}\e[0m"

    chain.each do |key, value|
      printf("%14s: %s\n", key, value)
    end
  end
end

blockchain = Blockchain.new()
put_string(blockchain.chain)
blockchain.create_block(5, 'hash 2')
put_string(blockchain.chain)
blockchain.create_block(6, 'hash 3')
put_string(blockchain.chain)