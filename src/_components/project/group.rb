# frozen_string_literal: true

module Project
  class Group < Bridgetown::Component
    def initialize(title: '', url: nil, url_title: nil)
      @title = title
      @url = url
      @url_title = url_title
    end
  end
end
