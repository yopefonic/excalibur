require 'spec_helper'
require 'excalibur/view_helpers'
require 'action_view/helpers'

class Dummy; end
class Klass; end

module Excalibur
  class DummyDecorator < Decorator; end

  describe ViewHelpers do
    let(:helpers) do
      klass = Klass.new.extend(ActionView::Helpers::TagHelper)
      klass.extend(ViewHelpers)
    end

    describe '#entitle' do
      let(:obj) { Dummy.new }

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

          helpers.entitle(Dummy.new)
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

          helpers.entitle(Dummy.new)
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
