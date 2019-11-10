# Model
db = {}


# Controller

# GET => /
def top
  #:TODO: Login
end

# GET => /blockchain
def blockchain
  blockchain = Blockchain.find()
  render :json @blockchain
end

# POST => /wallet
def wallet
  wallet = Wallet.new
  render :json wallet
end

# POST => /transaction
def transaction

end


private :get_blockchain

def get_blockchain
  cached_blockchain = db[:blockchain]
  if !cached_blockchain
    miners = Wallet.new
    db[:blockchain] = blockchain.Blockchain(miners.address)
    puts {
      priv_key: miners.priv_key,
      pub_key: miners.pub_key,
      address: miners.address
    }
    return db[:blockchain]
  end
end