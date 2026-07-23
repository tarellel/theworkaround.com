# frozen_string_literal: true

# Welcome to Bridgetown!
#
# This configuration file is for settings which affect your whole site.
#
# For more documentation on using this initializers file, visit:
# https://www.bridgetownrb.com/docs/configuration/initializers/
#
# For technical reasons, this file is *NOT* reloaded automatically when you use
# `bin/bridgetown start`. If you change this file, please restart the server process.
#
# Site-wide settings like url, title, permalink, and template_engine live in
# `bridgetown.config.yml`.

Bridgetown.configure do |config|
  # Plugins that register themselves as initializers must be booted explicitly
  # in Bridgetown 2.x.
  init :"bridgetown-feed"
  init :"bridgetown-seo-tag"
  init :"bridgetown-sitemap"
  init :"bridgetown-svg-inliner"
end
