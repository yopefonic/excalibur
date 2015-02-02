require 'draper'

module Excalibur
  # the Decorator class helps content to be derived from application base
  # object and turn them into Excalibur titles and meta tags. It's main
  # responsibilities are to make local classes configurable and it acts as a
  # connector between the application's objects and Excalibur.
  class Decorator < ::Draper::Decorator
    delegate_all

    attr_accessor :custom_configuration

    class << self
      attr_writer :configuration

      def exc_init(config = configuration)
        @configuration = config
      end

      def excalibur_init(*args)
        warn "[DEPRECATION] `excalibur_init` is deprecated.  Please use `exc_init` instead."
        exc_init(*args)
      end

      def configuration
        @configuration ||= ::Excalibur.configuration.dup
      end

      # methods:
      # excalibur_set_title_content, excalibur_set_title_option,
      # excalibur_set_title_combinator, excalibur_set_description_content,
      # excalibur_set_description_option, excalibur_set_description_combinator
      def method_missing(meth, *args)
        if meth.to_s =~ /^exc_(title|description+)_(content|option|combinator+)$/
          configuration.send($1).send("update_#{$2}", *args)
        elsif meth.to_s =~ /^excalibur_set_(title|description+)_(content|option|combinator+)$/
          warn "[DEPRECATION] `excalibur_set_#{$1}_#{$2}` is deprecated.  Please use `exc_#{$1}_#{$2}` instead."
          self.send("exc_#{$1}_#{$2}", *args)
        else
          super
        end
      end

      def exc_meta_tag(type, name, value = nil)
        configuration.set_meta_tag(type, name, value)
      end

      def excalibur_set_meta_tag(*args)
        warn "[DEPRECATION] `excalibur_set_meta_tag` is deprecated.  Please use `exc_meta_tag` instead."
        exc_meta_tag(*args)
      end
    end

    def initialize(object, options = {})
      configuration.merge!(options.delete(:config)) if options.key?(:config)

      super(object, options)
    end

    def configuration
      @custom_configuration ||= self.class.configuration.dup
    end

    def customize_configuration(config)
      configuration.merge!(config)
    end

    # methods: render_title, render_description
    def method_missing(meth, *args)
      if meth.to_s =~ /^render_(title|description+)$/
        obj = args.first || self
        subject = configuration.send($1)

        subject.to_s(obj) if subject.present?
      else
        super
      end
    end
  end
end
