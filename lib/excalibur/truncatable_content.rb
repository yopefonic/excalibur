module Excalibur
  # The TruncateableContent class is responsible for text content that is
  # constrained in length due to SEO specifications. Mainly used for title
  # and meta description tags this class facilitates the creation and proper
  # rendering of the content. A prefix/body/suffix data structure is used so
  # that only the body is truncated without having an effect on the branding
  # that is put before and/or after the body.
  class TruncateableContent
    include Duplicator

    attr_accessor :content
    attr_accessor :options
    attr_accessor :combinator

    def initialize(content = {}, options = {}, combinator = nil)
      @content = ::HashWithIndifferentAccess.new(content)
      @options = ::HashWithIndifferentAccess.new(options)
      @combinator = combinator
    end

    def can_merge?(obj)
      obj.is_a? TruncateableContent
    end

    def merge!(obj)
      if can_merge?(obj)
        @content.merge!(obj.content)
        @options.merge!(obj.options)
        @combinator = obj.combinator unless obj.combinator.nil?

        self
      else
        fail(TypeError.new(true),
             'can only merge two Excalibur::TruncateableContent objects')
      end
    end

    def dup
      self.class.new(
          dup_instance(@content),
          dup_instance(@options),
          dup_instance(@combinator)
      )
    end

    def get_content(key, obj = nil)
      if @content[key].instance_of?(Proc)
        @content[key].call(obj)
      elsif @content[key].nil?
        ''
      else
        @content[key]
      end
    end

    def update_content(key, value = nil)
      @content[key] = value
    end

    def update_option(key, value = nil)
      @options[key] = value
    end

    def update_combinator(value = nil)
      @combinator = value
    end

    def render_long(obj = nil)
      @content.map { |key, _value| get_content(key, obj).to_s }.inject(:+).to_s
    end

    def render_short(obj = nil)
      if @combinator.instance_of? Proc
        @combinator.call(obj)
      else
        render_long(obj)
      end
    end

    alias_method :to_s, :render_short
  end
end
