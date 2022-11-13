# module Icons
#   class Ruby < BaseComponent
module Icons
  class Github < Bridgetown::Component
    def initialize(alt: 'Github', color: 'text-gray-400', classes: 'h-6 w-6', size: '5')
      @alt = alt
      @color = color
      @classes = classes
      @size = size
    end
  end
end