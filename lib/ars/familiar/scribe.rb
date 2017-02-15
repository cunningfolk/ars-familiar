require 'active_support/inflector'
require 'fileutils'

module Ars
  module Familiar
    module Scribe

      class Entry < String
        def initialize(string)
          super(string.to_s)
        end

        def to_filename
          string = self.dup
          string.gsub!(/::/, '/')
          string.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
          string.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
          string.tr!("-", "_")
          string.downcase!
          string << '.dump'
          string
        end

        def to_class
          self.respond_to?(:name) ? self : self.constantize
        end
      end

      module Scribable
        def scribable(bool = nil)
          !bool.nil? && @scribable = bool
        end
        def scribable?
          @scribable
        end
        def self.extended(subclass)
          subclass.scribable true
          Scribe.register subclass
        end
      end

      @register = []

      def self.register(class_name = nil)
        return @register # bypass
        return @register unless class_name
        return @register if @register.member?(class_name)
        return @register unless class_name.builder.respond_to? :scribe
        @register << Entry.new(class_name)
        @register
      end

      def self.commit
        register.each do |entry|
          dump = Marshal.dump(entry.to_class.scribe)

          filename = File.join(Ars::Medium.configuration.root, 'lib/portable_models', model.to_filename)
          dirname = File.dirname filename
          FileUtils.mkdir_p dirname
          File.open(filename, 'w') do |file|
            file << dump
          end

        end
      end

      def self.read_for(model)
        model = Entry.new(model.class.name)

        filename = File.join(Ars::Medium.configuration.root, 'lib/portable_models', model.to_filename)
        dirname = File.dirname filename
        FileUtils.mkdir_p dirname
        if File.exist? filename
          File.open(filename, 'r') do |file|
            model.scribe Marshal.load(file)
          end
        end
      end

      def self.included(subclass)
        subclass.extend Scribable
      end

    end
  end
end
