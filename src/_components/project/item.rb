# frozen_string_literal: true

module Project
  class Item < Bridgetown::Component
    def initialize(name: '', description: '', github_url: nil, rubygems_url: nil, url: nil)
      @name = name
      @description = description
      @github_url = github_url
      @rubygems_url = rubygems_url
      @url = url
    end
  end
end
