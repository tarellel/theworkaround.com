# frozen_string_literal: true

module Post
  class Item < Bridgetown::Component
    attr_reader :post

    def initialize(post:)
      @post = post
    end

    # Format the posts data to a US readable format
    #
    # @example:
    #   Aug 27th, 2019
    # @return [String]
    def formatted_data
      # post&.data&.date&.strftime('%b %d, %Y')
      date_to_string(post&.data&.date, 'ordinal', 'US')
    end

    def post_length
      return 0 unless post&.content

      strip_html(post.content)&.split&.length
    end

    def post_word_txt
      return 'word' if post_length == 1

      'words'
    end

    # @return [String]
    def post_tags
      post.data.tags.map(&:capitalize).join(', ')
    end
  end
end
