require 'helper'

class TestThumbsUp < Test::Unit::TestCase
  def setup
    Vote.delete_all
    User.delete_all
    Item.delete_all
  end
  
  def test_acts_as_voter_instance_methods
    user_for = User.create(:name => 'david')
    user_against = User.create(:name => 'brady')
    item = Item.create(:name => 'XBOX', :description => 'XBOX console')
    
    assert_not_nil user_for.vote_for(item)
    assert_raises(ActiveRecord::RecordInvalid) do
      user_for.vote_for(item)
    end
    assert_equal true, user_for.voted_for?(item)
    assert_equal false, user_for.voted_against?(item)
    assert_equal true, user_for.voted_on?(item)
    assert_equal 1, user_for.vote_count
    assert_equal 1, user_for.vote_count(:up)
    assert_equal 0, user_for.vote_count(:down)
    assert_equal true, user_for.voted_which_way?(item, :up)
    assert_equal false, user_for.voted_which_way?(item, :down)
    assert_raises(ArgumentError) do
      user_for.voted_which_way?(item, :foo)
    end
    
    assert_not_nil user_against.vote_against(item)
    assert_raises(ActiveRecord::RecordInvalid) do
      user_against.vote_against(item)
    end
    assert_equal false, user_against.voted_for?(item)
    assert_equal true, user_against.voted_against?(item)
    assert_equal true, user_against.voted_on?(item)
    assert_equal 1, user_against.vote_count
    assert_equal 0, user_against.vote_count(:up)
    assert_equal 1, user_against.vote_count(:down)
    assert_equal false, user_against.voted_which_way?(item, :up)
    assert_equal true, user_against.voted_which_way?(item, :down)
    assert_raises(ArgumentError) do
      user_against.voted_which_way?(item, :foo)
    end
    
    assert_not_nil user_against.vote_exclusively_for(item)
    assert_equal true, user_against.voted_for?(item)

    assert_not_nil user_for.vote_exclusively_against(item)
    assert_equal true, user_for.voted_against?(item)
  end
end