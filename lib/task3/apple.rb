module Task3
	require 'yaml'
  class Apple
      attr_reader :variety, :origin, :history

      def initialize(**args)
        @variety = args[:variety]
        @origin = args[:origin]
        @history = args[:history]
      end
  end
end