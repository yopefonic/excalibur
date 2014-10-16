require 'spec_helper'
require 'excalibur/view_helpers'
require 'action_view/helpers'

class Dummy; end
class Klass; end
class OtherDecorator < Draper::Decorator; end

module Excalibur
  class DummyDecorator < Decorator; end

  describe ViewHelpers do
    let(:helpers) do
      klass = Klass.new.extend(ActionView::Helpers::TagHelper)
      klass.extend(ViewHelpers)
    end

    describe '#entitle' do
      context 'when dealing with a blank object' do
        let(:obj) { ::Dummy.new }

        it 'should try and decorate an object' do
          expect(DummyDecorator).to receive(:decorate).with(obj, {})

          helpers.entitle(obj, {})
        end

        it 'should set an instance variable' do
          helpers.entitle(obj, {})

          expect(helpers.instance_variable_get(:@excalibur_subject)).to be_present
          expect(helpers.instance_variable_get(:@excalibur_subject)).to be_instance_of DummyDecorator
        end
      end

      context 'when dealing with a custom object' do
        let(:obj) { true }

        it 'should try and decorate an object from a class' do
          expect(DummyDecorator).to receive(:decorate).with(obj, {})

          helpers.entitle(obj, class_name: ::Dummy)
        end

        it 'should try and decorate an object from a string' do
          expect(DummyDecorator).to receive(:decorate).with(obj, {})

          helpers.entitle(obj, class_name: 'Dummy')
        end
      end

      context 'when dealing with a decorated object' do
        let(:origin) { ::Dummy.new }
        let(:obj) { OtherDecorator.decorate(origin) }

        it 'should try and decorate an object' do
          expect(DummyDecorator).to receive(:decorate).with(origin, {})

          helpers.entitle(obj, {})
        end
      end
    end

    describe '#quick_set' do
      it 'should be able to set a meta tag' do
        expect_any_instance_of(Configuration).to receive(:set_meta_tag).with(:name, :description, 'quick set value')

        helpers.quick_set(:meta_tag, :name, :description, 'quick set value')

        expect(helpers.instance_variable_get(:@excalibur_subject)).to be_instance_of Decorator
      end

      [:title, :description].each do |type|
        it "should be able to set #{type} content" do
          expect_any_instance_of(TruncateableContent).to receive(:update_content).with(:body, 'quick set value')

          helpers.quick_set(type, :content, :body, 'quick set value')

          expect(helpers.instance_variable_get(:@excalibur_subject)).to be_instance_of Decorator
        end

        it "should be able to set #{type} options" do
          expect_any_instance_of(TruncateableContent).to receive(:update_option).with(:length, 42)

          helpers.quick_set(type, :option, :length, 42)

          expect(helpers.instance_variable_get(:@excalibur_subject)).to be_instance_of Decorator
        end

        it "should be able to set #{type} combinator" do
          expect_any_instance_of(TruncateableContent).to receive(:update_combinator).with('foobar')

          helpers.quick_set(type, :combinator, 'foobar')

          expect(helpers.instance_variable_get(:@excalibur_subject)).to be_instance_of Decorator
        end
      end
    end

    describe '#render_title_tag' do
      context 'when the configuration is standard' do
        it 'should return a title tag with the default content' do
          expect(helpers.render_title_tag).to eq '<title>Excalibur</title>'
        end
      end

      context 'when the configuration changed' do
        before do
          DummyDecorator.excalibur_set_title_content :body, 'New custom title'
          DummyDecorator.excalibur_set_title_content :prefix, '()==|::::::> '

          helpers.entitle(::Dummy.new)
        end

        it 'should return a title tag with the custom title content' do
          expect(helpers.render_title_tag).to eq '<title>()==|::::::&gt; New custom title</title>'
        end
      end
    end

    describe '#render_meta_tags' do
      context 'when the configuration is standard' do
        it 'should return a set of meta tags with the default content' do
          expect(helpers.render_meta_tags).to include '<meta content="Excalibur; a worthy title for a gem about titles." name="description" />'
          expect(helpers.render_meta_tags).to include '<meta content="width=device-width, initial-scale=1" name="viewport" />'
        end
      end

      context 'when the configuration changed' do
        before do
          DummyDecorator.excalibur_set_description_content :body, 'New custom description'
          DummyDecorator.excalibur_set_meta_tag :foo, :bar, 'baz'
          DummyDecorator.excalibur_set_meta_tag :foo, :array, ['foo', 'bar', 'baz']
          DummyDecorator.excalibur_set_meta_tag :foo, :proc, proc { |obj| obj.class.to_s }
          DummyDecorator.excalibur_set_meta_tag :foo, :nil, nil

          helpers.entitle(::Dummy.new)
        end

        it 'should return a title tag with the custom title content' do
          expect(helpers.render_meta_tags).to include '<meta content="New custom description" name="description" />'
          expect(helpers.render_meta_tags).to include '<meta content="width=device-width, initial-scale=1" name="viewport" />'
          expect(helpers.render_meta_tags).to include '<meta content="baz" foo="bar" />'
          expect(helpers.render_meta_tags).to include '<meta content="foo" foo="array" />'
          expect(helpers.render_meta_tags).to include '<meta content="bar" foo="array" />'
          expect(helpers.render_meta_tags).to include '<meta content="baz" foo="array" />'
          expect(helpers.render_meta_tags).to include '<meta content="Excalibur::DummyDecorator" foo="proc" />'
          expect(helpers.render_meta_tags).to_not include 'foo="nil" />'
        end
      end
    end
  end
end
