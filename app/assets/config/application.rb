require_relative 'boot'
require 'rails/all'

# ...

module BallMate
  class Application < Rails::Application
    config.time_zone = 'Tokyo'

    config.i18n.default_locale = :ja

    config.autoload_paths << Rails.root.join('lib')

    config.generators do |g|
      g.skip_routes true
      g.test_framework :rspec
      g.assets false
      g.helper false
    end
  end
end
