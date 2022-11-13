# module Icons
#   class Ruby < BaseComponent
module Icons
  class Link < Bridgetown::Component
    def initialize(alt: 'Link', color: 'text-gray-400', classes: 'h-6 w-6', size: '5')
      @alt = alt
      @color = color
      @classes = classes
      @size = size
    end
  end
end