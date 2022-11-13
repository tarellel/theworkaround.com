# module Icons
#   class Ruby < BaseComponent
module Icons
  class Ruby < Bridgetown::Component
    def initialize(alt: 'RubyGems', classes: 'h-10 w-10', size: '5')
      @alt = alt
      @classes = classes
      @size = size
    end
  end
end