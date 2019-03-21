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
  gem 'jekyll-assets'
  # gem 'jekyll-commonmark' # C based markdown compiler
  gem 'jekyll-commonmark-ghpages' # github flavor of commonmark (mainly to correct syntax highlighting issues)
  gem 'jekyll-minifier' # used for compressing the html and reducing the sites size
  gem 'jekyll-sass-converter' # github: 'jekyll/jekyll-sass-converter'
  gem 'jekyll-seo-tag'
  gem 'jekyll-tagging', github: 'pattex/jekyll-tagging'
end

########################################
# Formatting/Structure/Etc.
########################################
gem 'rouge' # Syntax Highlighting
gem 'uglifier'

########################################
# Assets and View related gems
########################################
gem 'bourbon'
gem 'rake'
