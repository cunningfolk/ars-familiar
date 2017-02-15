module Ars
  module Familiar
    class Mongoid < Base

      attr_reader :model, :model_name, :class_map

      def [](*args)
        ConstantizableArray[args]
      end

      def initialize(model)
        @model_name = model
        if Object.const_defined? model.to_s, true
          @model = model.constantize
        end
      end

      def primary_key!
        @primary_key =
          case
          when model.respond_to?(:primary_key)
            model.primary_key
          when model.respond_to?(:guid), model.public_method_defined?(:guid)
            :guid
          end
      end

      def primary_key
        @primary_key || primary_key!
      end

      def primary_key?
        !!primary_key
      end

      def id!
        @id = primary_key? ? primary_key : :id
      end

      def attributes_to_define!
        @attributes_to_define = standard_fields.keys.map(&:to_sym)
      end

      def standard_fields
        model.fields.select{|name, field| field.class.name == 'Mongoid::Fields::Standard'}.
          tap{|fields| fields[id] = fields.delete("_id") }
      end

      def relationships_to_define!(**opts)
        filter, class_map = extract_options(opts)

        @relationships_to_define =
          model.relations.values.select(&filter).flat_map { |relation|
          name = relation.fetch(:name)

          [*relation_switch(relation.fetch(:relation))].
            map{|rel| [rel, name, class_name: class_map[name]] }.
            compact
        }.compact
      end

      def relation_switch(name)
        case name.name
        when 'Mongoid::Relations::Embedded::Many', 'Mongoid::Relations::Referenced::Many'
          :has_many
        when 'Mongoid::Relations::Embedded::One',  'Mongoid::Relations::Referenced::One'
          :has_one
        when 'Mongoid::Relations::Referenced::ManyToMany'
          return :has_many, :belongs_to
        else
          raise StandardError, "Unknown Relationship: #{name}"
        end
      end

    end
  end
end

