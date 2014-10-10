require 'generator_spec'
require 'generators/excalibur/decorator_generator'

module Excalibur
  describe Generators::DecoratorGenerator do
    destination File.expand_path('../../tmp', __FILE__)
    arguments %w(dummy)

    before(:all) do
      prepare_destination
      run_generator
    end

    it 'should create the correct file and content' do
      expect(destination_root).to have_structure {
        directory 'app' do
          directory 'decorators' do
            directory 'excalibur' do
              file 'dummy_decorator.rb' do
                contains 'class Excalibur::DummyDecorator < Excalibur::Decorator'
              end
            end
          end
        end
      }
    end
  end
end
