class Cache
  attr_reader :alice, :bob, :blockchain

  def initialize
    @alice = Wallet.new
    @bob = Wallet.new
    @miner = Wallet.new
    @blockchain = Blockchain.new(@miner.address)
  end

  def get_wallet_cache
    [@alice.get_wallet, @bob.get_wallet]
  end
end
