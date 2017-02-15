module Ars
  module Familiar
    class Base

      def scribe(dump)
        if dump
          %i{ attributes_to_define relationships_to_define primary_key id }.each do |attr|
            const_set "@#{attr}", dump[attr]
          end
        end
        {
          attributes_to_define: @attributes_to_define,
          relationships_to_define: @relationships_to_define,
          primary_key: @primary_key,
          id: @id
        }
      end

      def id
        @id || id!
      end

      def attributes_to_define
        @attributes_to_define || attributes_to_define!
      end

      def relationships_to_define(**opts)
        @relationships_to_define || relationships_to_define!(**opts)
      end

      def extract_options(**opts)
        class_map = map_classes(opts)

        only = opts.fetch(:only, :pass).entries.each_with_object(class_map) {|val, hash|  hash.store(*val) }.keys
        class_map

        filter = proc do |relation|
          name = relation[:name]

          only == :pass || only.include?(name)
        end

        [filter, class_map]
      end

      def map_classes(**opts)
        class_base  = opts.fetch(:class_base, nil)
        class_name  = opts.fetch(:class_name, false)
        class_names = opts.fetch(:class_names, {})

        Hash.new {|hash, key| hash[key] = [class_base, key].constantize }.
          tap {|this| class_name && this.default = class_name}.
          merge(class_names)
      end

    end
  end
end
