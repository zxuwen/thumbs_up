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
  
  def test_acts_as_voteable_instance_methods
    user_for = User.create(:name => 'david')
    another_user_for = User.create(:name => 'name')
    user_against = User.create(:name => 'brady')
    item = Item.create(:name => 'XBOX', :description => 'XBOX console')

    user_for.vote_for(item)
    another_user_for.vote_for(item)
    
    assert_equal 2, item.votes_for
    assert_equal 0, item.votes_against
    assert_equal 2, item.plusminus

    user_against.vote_against(item)
    
    assert_equal 1, item.votes_against
    assert_equal 1, item.plusminus
    
    assert_equal 3, item.votes_count
    
    voters_who_voted = item.voters_who_voted
    assert_equal 3, voters_who_voted.size    
    assert voters_who_voted.include?(user_for)
    assert voters_who_voted.include?(another_user_for)
    assert voters_who_voted.include?(user_against)
    
    non_voting_user = User.create(:name => 'random')
    
    assert_equal true, item.voted_by?(user_for)
    assert_equal true, item.voted_by?(another_user_for)
    assert_equal true, item.voted_by?(user_against)
    assert_equal false, item.voted_by?(non_voting_user)
  end
end