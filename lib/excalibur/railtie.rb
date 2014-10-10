require 'excalibur/view_helpers'

module Excalibur
  # ties the ViewHelpers into Rails and allows them to be used in the views
  class Railtie < Rails::Railtie
    initializer 'excalibur.view_helpers' do
      ActionView::Base.send :include, ViewHelpers
    end

    generators do
      require 'generators/excalibur/install_generator'
      require 'generators/excalibur/decorator_generator'
    end
  end
end
