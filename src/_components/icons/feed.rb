# frozen_string_literal: true

module Icons
  class Feed < Bridgetown::Component
    def initialize(alt: 'RSS Feed Icon', classes: 'h-10 w-10', size: '5')
      @alt = alt
      @classes = classes
      @size = size
    end
  end
end
