require 'generator_spec'
require 'generators/excalibur/install_generator'

module Excalibur
  describe Generators::InstallGenerator do
    destination File.expand_path('../../tmp', __FILE__)

    before(:all) do
      prepare_destination
      run_generator
    end

    it 'creates a test initializer' do
      assert_file 'config/initializers/excalibur.rb'
    end

    it 'should copy the template initializer over to the app config' do
      expect(destination_root).to have_structure {
        no_file 'excalibur.rb'
        directory 'config' do
          directory 'initializers' do
            file 'excalibur.rb' do
              contains 'Excalibur.configure do |config|'
            end
          end
        end
      }
    end
  end
end
