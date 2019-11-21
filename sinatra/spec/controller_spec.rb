require File.expand_path '../spec_helper.rb', __FILE__


describe 'GET /wallet' do
  before do
    get '/wallet'
  end

  it 'returns OK' do
    expect(last_response).to be_ok
  end
  # [
  #   {
  #     "priv_key"=>"Lzhp9LopCC6XVbzduGKCknFNN6hs6pzGXUjeoWpX1C6cmyqi79bVVZkCGF5uoYeo8hrg6QZ2vxXeaqW3LfNCP897MiFM9N5uTFiHGFwJHzLPcs1DWrReUy69nzFW3n9KDK8usMXdV1WfrffFZFPboRXrazDwZ5A2j",
  #     "pub_key"=>"PZ8Tyr4Nx8MHsRAGMpZmZ6TWY63dXWSCyjQaff5FQmgnnA5GRvXFJGYeJFKQYtggZffsiR3B66LQMH2L9bf9rdaqBREZyLMkJJPyDrrwcWmr5rt9DB1vGiab",
  #     "address"=>"2GJCx8xffUNLnbxe9fi82irgx7XQqsbEb9q"
  #   },
  #   {
  #     "priv_key"=>"Lzhp9LopCFQJKXzWgzsAH5LU1ZjC8vBZY9gZ8UNVjU5JoeMEhybB9WruibAiDWjJkTWKunoDC4H4DTsQEK7b6uvovWVjBzUcnCjkXDDhjFubvdSS9GYz1rqNxZagWWG6ENTBTpgz5ZoSyuXwUKdFWk8qQDLYwbPcp",
  #     "pub_key"=>"PZ8Tyr4Nx8MHsRAGMpZmZ6TWY63dXWSCyoHXUkEqCMTfEy1EC3j5EvBpn8Deu6HbA5XH3PUojFby76VyRnU99aiSPeEvnSki88SyapSXhN1PzPtMgkDiXxrp",
  #     "address"=>"2KYmE5rfkCYvQWqe117211pREmYkL7H6Atf"
  #   }
  # ]
  it "returns 2 elements in Array" do
    body = JSON.parse(last_response.body)
    p 'RSpec GET /wallet', body
    expect(body.class).to eq Array
    expect(body.length).to eq 2
  end
end

describe 'POST /send' do
  let(:headers) do
    { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
  end

  let(:data) do
    {
      "sender_priv_key": "Lzhp9LopCC6XVbzduGKCknFNN6hs6pzGXUjeoWpX1C6cmyqi79bVVZkCGF5uoYeo8hrg6QZ2vxXeaqW3LfNCP897MiFM9N5uTFiHGFwJHzLPcs1DWrReUy69nzFW3n9KDK8usMXdV1WfrffFZFPboRXrazDwZ5A2j",
      "sender_pub_key": "PZ8Tyr4Nx8MHsRAGMpZmZ6TWY63dXWSCyjQaff5FQmgnnA5GRvXFJGYeJFKQYtggZffsiR3B66LQMH2L9bf9rdaqBREZyLMkJJPyDrrwcWmr5rt9DB1vGiab",
      "sender_address":  "2GJCx8xffUNLnbxe9fi82irgx7XQqsbEb9q",
      "recipient_address": "2KYmE5rfkCYvQWqe117211pREmYkL7H6Atf",
      "value": 100
    }.to_json.to_s
  end

  it 'returns OK' do
    post '/send', data, headers
    expect(last_response).to be_ok
  end
end

describe 'GET /pool' do
  before do
    get '/pool'
  end

  it 'returns OK' do
    expect(last_response).to be_ok
  end

  it 'returns Array' do
    body = JSON.parse(last_response.body)
    p 'RSpec GET /pool', body
    expect(body.class).to eq Array
  end
end

describe 'GET /mine' do
  before do
    get '/mine'
  end

  it 'returns OK' do
    expect(last_response).to be_ok
  end

  it 'returns True or False' do
    body = last_response.body
    # body = JSON.parse(last_response.body) :FIXME: Boolean Response
    p 'RSpec GET /mine', body
    expect(body.class).to eq String
    # expect(body.class).to eq(True).or eq(False)
  end
end

describe 'GET /chain' do
  before do
    get '/chain'
  end

  it 'returns OK' do
    expect(last_response).to be_ok
  end

  it 'returns Array' do
    body = JSON.parse(last_response.body)
    p 'RSpec GET /chain', body
    expect(body.class).to eq Array
  end
end