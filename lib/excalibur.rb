require 'excalibur/version'
require 'active_support/all'
require 'excalibur/decorator'
require 'excalibur/duplicator'
require 'excalibur/configuration'
require 'excalibur/truncatable_content'
require 'excalibur/railtie' if defined?(Rails)

# the Excalibur gem helps you to decorate a rails app with proper title and
# meta tags for every page. It does this by providing default configuration
# options, object based decorators for customization per object type and
# helpers to put in on the page.
module Excalibur
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= new_default_configuration
    end

    def reset
      @configuration = new_default_configuration
    end

    # defines the gem default
    def new_default_configuration
      Configuration.new(
          new_default_title,
          new_default_description,
          new_default_meta_tags
      )
    end

    def configure
      yield(configuration)
    end

    private

    def new_default_title
      TruncateableContent.new(
          { body: 'Excalibur' },
          { length: 69, omission: '...', separator: '' },
          proc do |obj|
            if obj.present?
              t = obj.configuration.title

              length  = t.options[:length]
              length -= t.get_content(:prefix, obj).length
              length -= t.get_content(:suffix, obj).length

              res  = t.get_content(:prefix, obj)
              res += t.get_content(:body, obj).truncate(length, t.options)
              res +  t.get_content(:suffix, obj)
            end
          end
      )
    end

    def new_default_description
      TruncateableContent.new(
          { body: 'Excalibur; a worthy title for a gem about titles.' },
          { length: 155, omission: '...', separator: ' ' },
          proc do |obj|
            if obj.present?
              d = obj.configuration.description

              length  = d.options[:length]
              length -= d.get_content(:prefix, obj).length
              length -= d.get_content(:suffix, obj).length

              res  = d.get_content(:prefix, obj)
              res += d.get_content(:body, obj).truncate(length, d.options)
              res +  d.get_content(:suffix, obj)
            end
          end
      )
    end

    def new_default_meta_tags
      ::HashWithIndifferentAccess.new(
          name: ::HashWithIndifferentAccess.new(
              description: proc { |obj| obj.render_description },
              viewport: 'width=device-width, initial-scale=1'
          )
      )
    end
  end
end
