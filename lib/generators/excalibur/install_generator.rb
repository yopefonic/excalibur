require 'rails/generators/base'

module Excalibur
  module Generators
    # the install generator allows you to get a free to use and fully
    # documented initializer file for your rails app by running:
    # rails g excalibur:install
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)

      desc 'Creates a Excalibur initializer.'

      def copy_initializer
        template 'excalibur.rb', 'config/initializers/excalibur.rb'
      end
    end
  end
end
