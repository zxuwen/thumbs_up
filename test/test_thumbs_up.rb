require 'helper'

class TestThumbsUp < Test::Unit::TestCase
  def setup
    Vote.delete_all
    User.delete_all
    Item.delete_all
  end
  
  def test_acts_as_voter_instance_methods
    user = User.create(:name => 'david')
    item = Item.create(:name => 'XBOX', :description => 'XBOX console')
    
    assert_not_nil user.vote_for(item)
    assert_equal true, user.voted_for?(item)
  end
end