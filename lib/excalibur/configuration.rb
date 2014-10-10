module Excalibur
  # the Configuration class is responsible for holding the configurable data
  # and logic that will be passed down
  class Configuration
    include Duplicator

    attr_accessor :title
    attr_accessor :description
    attr_accessor :meta_tags

    def initialize(
        title = TruncateableContent.new,
        description = TruncateableContent.new,
        meta_tags = ::HashWithIndifferentAccess.new({}))
      @title = title
      @description = description
      @meta_tags = meta_tags
    end

    def merge!(obj)
      if obj.is_a? Configuration
        @title = merge_instance(@title, obj.title)
        @description = merge_instance(@description, obj.description)
        @meta_tags = merge_instance(@meta_tags, obj.meta_tags)

        self
      else
        fail(TypeError.new(true),
             'can only merge two Excalibur::Configuration objects')
      end
    end

    def dup
      self.class.new(
          dup_instance(@title),
          dup_instance(@description.dup),
          dup_instance(@meta_tags.dup))
    end

    def set_meta_tag(type, name, value = nil)
      if @meta_tags[type].nil?
        @meta_tags[type] = ::HashWithIndifferentAccess.new
      end

      @meta_tags[type][name] = value
    end

    def remove_meta_tag(type, name)
      @meta_tags[type].delete(name) if @meta_tags[type].present?
      @meta_tags.delete(type) if @meta_tags[type].empty?
    end

    private

    def merge_instance(old, new)
      if old.is_a? new.class
        merge_content(old, new)
      elsif !new.nil?
        new
      else
        old
      end
    end

    def merge_content(old, new)
      if old.is_a? ::Hash
        old.deep_merge!(new)
      elsif old.is_a? TruncateableContent
        old.merge!(new)
      elsif old.is_a? ::String
        old + new
      else
        new
      end
    end
  end
end
