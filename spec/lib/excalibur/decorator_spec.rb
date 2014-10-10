require 'spec_helper'

module Excalibur
  class Dummy; end
  class DummyDecorator < Decorator; end

  describe Decorator do
    before do
      Excalibur.reset
      DummyDecorator.configuration = nil
    end

    after do
      DummyDecorator.configuration = nil
    end

    describe '#new' do
      context 'when creating it without options' do
        let(:obj) { DummyDecorator.decorate(Dummy.new) }

        it { expect(obj.context).to be_empty }
        it { expect(obj.configuration).to be_present }
      end

      context 'when creating it with options' do
        context 'when providing context' do
          let(:obj) { DummyDecorator.decorate(Dummy.new, context: {foo: 'bar'}) }

          it { expect(obj.context).to_not be_empty }
          it { expect(obj.context).to eq({foo: 'bar'}) }
        end

        context 'when providing config' do
          let(:config) { Configuration.new }
          let(:obj) { DummyDecorator.decorate(Dummy.new, config: config) }

          it 'should try and merge the configuration' do
            expect_any_instance_of(Configuration).to receive(:merge!).with(config)

            obj
          end
        end
      end
    end

    context 'when configuring a decorator with mixed methods' do
      before do
        DummyDecorator.configuration = nil

        class DummyDecorator < Decorator
          excalibur_set_meta_tag(:foo, :bar, proc { |obj| 'content' })
          excalibur_set_meta_tag(:name, :other, 'content')

          excalibur_set_title_content(:prefix, 'Exc / ')
          excalibur_set_title_content(:body, 'title body')
          excalibur_set_title_option(:length, 42)
          excalibur_set_title_combinator proc{ |obj| "result #{obj}" }

          excalibur_set_description_content(:body, 'title body')
          excalibur_set_description_option(:length, 42)
          excalibur_set_description_combinator proc{ |obj| "result #{obj}" }
        end
      end

      it { expect(DummyDecorator.configuration.meta_tags).to have_key(:name) }
      it { expect(DummyDecorator.configuration.meta_tags[:name]).to have_key(:other) }
      it { expect(DummyDecorator.configuration.meta_tags).to have_key(:foo) }
      it { expect(DummyDecorator.configuration.meta_tags[:foo]).to have_key(:bar) }

      it { expect(DummyDecorator.configuration.title.content[:prefix]).to eq 'Exc / ' }
      it { expect(DummyDecorator.configuration.title.content[:body]).to eq 'title body' }
      it { expect(DummyDecorator.configuration.title.options[:length]).to eq 42 }
      it { expect(DummyDecorator.configuration.title.combinator).to be_instance_of Proc }
      it { expect(DummyDecorator.configuration.title.combinator.call('foobar')).to eq('result foobar') }

      it { expect(DummyDecorator.configuration.description.content[:body]).to eq 'title body' }
      it { expect(DummyDecorator.configuration.description.options[:length]).to eq 42 }
      it { expect(DummyDecorator.configuration.description.combinator).to be_instance_of Proc }
      it { expect(DummyDecorator.configuration.description.combinator.call('foobar')).to eq('result foobar') }
    end

    describe '::excalibur_init' do
      context 'when creating a decorator' do
        context 'when setting the config without a value' do
          before do
            class DummyDecorator < Decorator
              excalibur_init
            end
          end

          it { expect(DummyDecorator.configuration).to be_present }
          it { expect(DummyDecorator.configuration).to be_instance_of Configuration }
        end

        context 'when setting the config with a value' do
          before do
            class DummyDecorator < Decorator
              excalibur_init true
            end
          end

          it { expect(DummyDecorator.configuration).to be_present }
          it { expect(DummyDecorator.configuration).to eq(true) }
        end
      end
    end

    describe '::configuration' do
      it 'should duplicate the system wide configuration' do
        expect( Excalibur.configuration ).to receive(:dup)

        DummyDecorator.configuration
      end

      it 'should only duplicate the system wide configuration once' do
        DummyDecorator.configuration

        expect( Excalibur.configuration ).to_not receive(:dup)

        DummyDecorator.configuration
      end
    end

    describe '::excalibur_set' do
      describe '_title' do
        describe '_content' do
          it 'should change the title content' do
            expect {
              DummyDecorator.excalibur_set_title_content(:foo, 'bar')
            }.to change(DummyDecorator.configuration.title, :content).to(body: 'Excalibur', foo: 'bar')
          end
        end

        describe '_option' do
          it 'should change the title options' do
            expect {
              DummyDecorator.excalibur_set_title_option(:foo, 'bar')
            }.to change(DummyDecorator.configuration.title, :options).to(length: 69, omission: '...', separator: '', foo: 'bar')
          end
        end

        describe '_combinator' do
          it 'should change the title combinator' do
            expect {
              DummyDecorator.excalibur_set_title_combinator(true)
            }.to change(DummyDecorator.configuration.title, :combinator).to(true)
          end
        end
      end

      describe '_description' do
        describe '_content' do
          it 'should change the description content' do
            expect {
              DummyDecorator.excalibur_set_description_content(:foo, 'bar')
            }.to change(DummyDecorator.configuration.description, :content).to(body: 'Excalibur; a worthy title for a gem about titles.', foo: 'bar')
          end
        end

        describe '_option' do
          it 'should change the description options' do
            expect {
              DummyDecorator.excalibur_set_description_option(:foo, 'bar')
            }.to change(DummyDecorator.configuration.description, :options).to(length: 155, omission: '...', separator: ' ', foo: 'bar')
          end
        end

        describe '_combinator' do
          it 'should change the description combinator' do
            expect {
              DummyDecorator.excalibur_set_description_combinator(true)
            }.to change(DummyDecorator.configuration.description, :combinator).to(true)
          end
        end
      end

      describe '_meta_tag' do
        it 'should change the meta tags' do
          expect(DummyDecorator.configuration).to receive(:set_meta_tag).with(:name, :description, 'foobar')

          DummyDecorator.excalibur_set_meta_tag(:name, :description, 'foobar')
        end
      end
    end

    describe '#configuration' do
      let(:obj) { DummyDecorator.decorate(Dummy.new) }

      it "should duplicate the decorator's configuration" do
        expect(obj.class.configuration).to receive(:dup)

        obj.configuration
      end

      it 'should return a configuration' do
        expect(obj.configuration).to be_instance_of Configuration
      end
    end

    describe '#customize_configuration' do
      let(:obj) { DummyDecorator.decorate(Dummy.new) }

      it 'should merge the input with the configuration' do
        expect(obj.configuration).to receive(:merge!).with('foobar')

        obj.customize_configuration('foobar')
      end
    end

    describe '#render_title' do
      let(:obj) { DummyDecorator.decorate(Dummy.new) }

      context 'when using the default settings' do
        it { expect(obj.render_title).to eq('Excalibur') }

        it 'should call to_s in the title' do
          expect(obj.configuration.title).to receive(:to_s)

          obj.render_title
        end
      end
    end
  end
end
