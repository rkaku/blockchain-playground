class Blockchain

  attr :transaction_pool, :chain

  def initialize
    @transaction_pool = []
    @chain = []
    create_block(0, 'hash 0')
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

blockchain = Blockchain.new()
p blockchain.chain
blockchain.create_block(5, 'hash 1')
p blockchain.chain
blockchain.create_block(6, 'hash 2')
p blockchain.chain

# def put_string(chans)