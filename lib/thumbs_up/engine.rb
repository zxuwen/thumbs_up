require 'rails'
require 'thumbs_up'

module ThumbsUp
  class Engine < Rails::Engine
    engine_name :thumbs_up
  end
end

# Alias the model unless the host application already has a Vote model.
Vote = ThumbsUp::Vote unless defined?(Vote)