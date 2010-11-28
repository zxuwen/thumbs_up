require 'acts_as_voteable'
require 'acts_as_voter'
require 'has_karma'
require 'thumbs_up/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3

ActiveRecord::Base.send(:include, ThumbsUp::ActsAsVoteable)
ActiveRecord::Base.send(:include, ThumbsUp::ActsAsVoter)
ActiveRecord::Base.send(:include, ThumbsUp::Karma)