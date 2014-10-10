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

      def excalibur_init(config = configuration)
        @configuration = config
      end

      def configuration
        @configuration ||= ::Excalibur.configuration.dup
      end

      def method_missing(meth, *args)
        if meth.to_s =~ /^excalibur_set_(title|description+)_(content|option|combinator+)$/
          configuration.send($1).send("update_#{$2}", *args)
        else
          super
        end
      end

      def excalibur_set_meta_tag(type, name, value = nil)
        configuration.set_meta_tag(type, name, value)
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

    def render_title(obj = self)
      configuration.title.to_s(obj) if configuration.title.present?
    end
  end
end
