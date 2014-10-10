require 'rails/generators/base'

module Excalibur
  module Generators
    # allows you to use rails generate to create a new scaffolded decorator
    # for a application native class.
    # rails g excalibur:decorator [class_name]
    class DecoratorGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../../templates', __FILE__)

      desc 'Creates a Excalibur decorator.'

      def create_decorator
        template 'decorator.rb', "app/decorators/excalibur/#{file_name}_decorator.rb"
      end
    end
  end
end
