module Excalibur
  # the ViewHelpers module contains the methods to access Excalibur from the
  # view. Most commonly placed in the view templates and the application Layout
  module ViewHelpers
    def entitle(object, options = {})
      @excalibur_subject = excalibur_decorate_subject(object, options)
    end

    def render_title_tag
      content_tag :title, excalibur_subject.render_title
    end

    def render_meta_tags
      result = ''

      excalibur_subject.configuration.meta_tags.each do |type_name, value|
        value.each do |type_value, contents|
          next if contents.nil?
          contents = render_meta_content(contents)
          contents = [contents] unless contents.is_a?(Array)

          contents.each do |content|
            result << tag(
                :meta,
                type_name => type_value,
                content: content
            ) unless content.nil?
          end
        end
      end

      result.html_safe
    end

    private

    def render_meta_content(content)
      if content.is_a? Proc
        content.call(excalibur_subject)
      else
        content
      end
    end

    def excalibur_subject
      @excalibur_subject ||= new_blank_excalibur_subject
    end

    def new_blank_excalibur_subject
      ::Excalibur::Decorator.decorate(true)
    end

    def excalibur_decorate_subject(object, options = {})
      Object.const_get(
          "::Excalibur::#{object.class.name}Decorator"
      ).decorate(object, options)
    end
  end
end
