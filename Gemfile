source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'jekyll'

# A C library for faster Liquid template compiling
gem 'liquid', github: 'Shopify/liquid', branch: 'master'
gem 'liquid-c', github: 'Shopify/liquid-c', branch: 'master'

########################################
# Jekyll plugins
########################################
group :jekyll_plugins do
  gem 'jekyll-assets'             #, github: 'envygeeks/jekyll-assets'
  # gem 'jekyll-commonmark'       # C based markdown compiler
  gem 'jekyll-commonmark-ghpages' # github flavor of commonmark (mainly to correct syntax highlighting issues)
  gem 'jekyll-minifier'           # used for compressing the html and reducing the sites size
  gem 'jekyll-compress-images', github: 'valerijaspasojevic/jekyll-compress-images'
  # Other gem to lookat - https://github.com/chrisanthropic/image_optim-jekyll-plugin
  gem 'jekyll-sass-converter'     # github: 'jekyll/jekyll-sass-converter'
  gem 'jekyll-seo-tag'
  gem 'jekyll-tagging', github: 'pattex/jekyll-tagging'
  gem 'sprockets', '3.7.2'
end
gem 'autoprefixer-rails'
# Used for image compression
gem 'image_optim'
gem 'image_optim_pack'            # Optional

########################################
# Formatting/Structure/Etc.
########################################
gem 'rouge'                       # Syntax Highlighting
gem 'uglifier'                    # Asset compression

########################################
# Assets and View related gems
########################################
gem 'rake'
