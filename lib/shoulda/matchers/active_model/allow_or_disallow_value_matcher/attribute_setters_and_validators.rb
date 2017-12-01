module Shoulda
  module Matchers
    module ActiveModel
      class AllowOrDisallowValueMatcher
        # @private
        class AttributeSettersAndValidators
          include Enumerable

          def initialize(allow_value_matcher, values)
            @tuples = values.map do |attribute_name, value|
              AttributeSetterAndValidator.new(
                allow_value_matcher,
                attribute_name,
                value
              )
            end
          end

          def each(&block)
            tuples.each(&block)
          end

          def first_to_unexpectedly_not_pass
            tuples.detect(&method(:fails_to_pass?))
          end

          def first_to_unexpectedly_not_fail
            tuples.detect(&method(:fails_to_fail?))
          end

          def pretty_print(pp)
            Shoulda::Matchers::Util.pretty_print(self, pp, {
              tuples: tuples,
            })
          end

          protected

          attr_reader :tuples

          private

          def fails_to_pass?(tuple)
            tuple.attribute_setter.set!
            !tuple.validator.passes?
          end

          def fails_to_fail?(tuple)
            tuple.attribute_setter.set!
            !tuple.validator.fails?
          end
        end
      end
    end
  end
end
