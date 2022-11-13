# frozen_string_literal: true

module Post
  class Item < Bridgetown::Component
    attr_reader :post

    def initialize(post:)
      @post = post
    end
  end
end
