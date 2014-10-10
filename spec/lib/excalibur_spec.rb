require 'spec_helper'

module Excalibur
  describe '::configure' do
    context 'when the config is empty' do
      let(:obj) { Decorator.new(true) }

      before do
        Excalibur.configure {}
      end

      it 'should create a configuration' do
        expect(Excalibur.configuration).to be_present
        expect(Excalibur.configuration).to be_instance_of Configuration
      end

      it 'should set the config default objects' do
        expect(Excalibur.configuration.title).to be_instance_of TruncateableContent
        expect(Excalibur.configuration.description).to be_instance_of TruncateableContent
        expect(Excalibur.configuration.meta_tags).to be_instance_of ::HashWithIndifferentAccess
      end

      it 'should have the correct title value' do
        expect(Excalibur.configuration.title.to_s(obj)).to eq('Excalibur')
      end

      it 'should have the correct description value' do
        expect(Excalibur.configuration.description.to_s(obj)).to eq('Excalibur; a worthy title for a gem about titles.')
      end

      after do
        Excalibur.reset
      end
    end

    context 'when the config is contains changes' do
      before do
        Excalibur.configure do |config|
          config.title = 'Foobar'
        end
      end

      it 'should set the config default objects' do
        expect(Excalibur.configuration.description).to be_instance_of TruncateableContent
        expect(Excalibur.configuration.meta_tags).to be_instance_of ::HashWithIndifferentAccess
      end

      it 'should have the changed title' do
        expect(Excalibur.configuration.title).to be_instance_of ::String
        expect(Excalibur.configuration.title.to_s).to eq('Foobar')
      end

      after do
        Excalibur.reset
      end
    end
  end

  describe '::configuration' do
    before do
      @config = Excalibur.configuration
    end

    it 'should create only one new' do
      expect(Configuration).to_not receive(:new)
      expect(Excalibur.configuration).to eq(@config)
    end
  end

  describe '::reset' do
    before do
      Excalibur.configure do |config|
        config.title = 'Foobar'
      end
    end

    it 'should set the config value' do
      @old = Excalibur.configuration

      Excalibur.reset

      expect(Excalibur.configuration.title).to_not equal(@old.title)
    end
  end
end
