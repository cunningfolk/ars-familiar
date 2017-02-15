require "ars/familiar/version"
require 'active_support/inflector'

module Ars
  module Familiar
    autoload :Mongoid, 'ars/familiar/mongoid'
    autoload :Base,    'ars/familiar/base'
    autoload :Scribe,  'ars/familiar/scribe'

    module DSL
      attr_reader :builder

      def shadow(model)
        consume = model.dup
        model = Familiar::Mongoid.new(model)
        consumed = consume.constantize rescue false
        unless consumed
          Scribe.read_for model
        end
        @builder = model
      end

      def realize_attributes!
        primary_key builder.primary_key if builder.primary_key?
        attributes builder.attributes_to_define
      end

      def realize_relationships!(**opts)
        builder.relationships_to_define(opts).each do |relationship|
          self.send(*relationship)
        end
      end
    end

    def self.included(subclass)
      subclass.extend DSL
    end
  end
end
