require 'spec_helper'

module Excalibur
  describe Configuration do
    describe '#new' do
      context 'when creating a configuration without parameters' do
        let(:config) { Configuration.new }

        it 'should create a title' do
          expect(config.title).to be_instance_of TruncateableContent
        end

        it 'should create a describe' do
          expect(config.description).to be_instance_of TruncateableContent
        end

        it 'should create an empty meta tags hash' do
          expect(config.meta_tags).to be_instance_of ::HashWithIndifferentAccess
          expect(config.meta_tags).to be_empty
        end
      end

      context 'when supplying parameters' do
        let(:config) { Configuration.new('foo', 'bar', 'baz') }

        it 'should set the right values' do
          expect(config.title).to eq('foo')
          expect(config.description).to eq('bar')
          expect(config.meta_tags).to eq('baz')
        end
      end
    end

    describe '#merge!' do
      context 'when trying to merge with the wrong type of object' do
        let(:obj) { Configuration.new }

        it 'should raise a TypeError' do
          expect { obj.merge!('foo') }.to raise_error(TypeError, 'can only merge two Excalibur::Configuration objects')
        end
      end

      context 'when merging two configurations' do
        let(:obj_a) { Configuration.new(TruncateableContent.new, TruncateableContent.new) }
        let(:obj_b) { Configuration.new(TruncateableContent.new, false, nil) }

        context 'instance result' do
          after do
            obj_a.merge!(obj_b)
          end

          it 'should merge the instance variables' do
            expect(obj_a).to receive(:merge_instance).exactly(3).times
          end
        end

        context 'function result' do
          it 'should return itself' do
            expect(obj_a.merge!(obj_b)).to be_instance_of Configuration
          end
        end
      end

      describe 'when merging content merging' do
        let(:a) { 'foobar' }
        let(:b) { 'baz' }
        let(:config) { Configuration.new(a) }
        let(:new_config) { Configuration.new(b) }

        before do
          config.merge!(new_config)
        end

        context 'when the objects are different classes' do
          context 'when the new object is nil' do
            let(:new_config) { Configuration.new(nil) }

            it 'should not change the config variable' do
              expect( config.title ).to eq(config.title)
            end
          end

          context 'when the new object is a value' do
            let(:new_config) { Configuration.new(true) }

            it 'should change the config variable' do
              expect( config.title ).to eq(true)
            end
          end
        end

        context 'when the objects are the same class' do
          context 'when merging two hashes' do
            let(:a) { {foo: {bar: 'baz', other: 'old'}} }
            let(:b) { {foo: {other: 'new'}} }

            it 'should deep merge the two hashes' do
              expect(config.title).to eq( { foo: {bar: 'baz', other: 'new'} } )
            end
          end

          context 'when merging two TruncatableContent' do
            let(:config) { Configuration.new }
            let(:b) { TruncateableContent.new({foo: 'bar'}, {foo: 'bar'}, 'foobar') }

            it 'should merge the two TruncatableContent' do
              expect(config.title.content).to eq( b.content )
              expect(config.title.options).to eq( b.options )
              expect(config.title.combinator).to eq( b.combinator )
            end
          end

          context 'when merging two strings' do
            let(:a) { 'foo' }
            let(:b) { 'bar' }

            it 'should concatenate the two strings' do
              expect(config.title).to eq('foobar')
            end
          end

          context 'when merging something else' do
            let(:a) { true }
            let(:b) { false }

            it 'should replace it' do
              expect(config.title).to eq(false)
            end
          end
        end
      end
    end

    describe '#dup' do
      it 'should create a duplicate of the object and the attributes' do
        expect(Excalibur.configuration.title).to receive(:dup)
        expect(Excalibur.configuration.description).to receive(:dup)
        expect(Excalibur.configuration.meta_tags).to receive(:dup)

        Excalibur.configuration.dup
      end

      it 'should create a duplicate of the object and the attributes' do
        expect(Excalibur.configuration).to receive(:dup_instance).exactly(3).times

        Excalibur.configuration.dup
      end
    end

    describe '#set_meta_tag' do
      let(:config) do
        c = Configuration.new
        c.meta_tags = ::HashWithIndifferentAccess.new( name: ::HashWithIndifferentAccess.new( description: 'old' ) )
        c
      end

      it 'should overwrite a tag' do
        config.set_meta_tag(:name, :description, 'Description content')

        expect(config.meta_tags).to eq(::HashWithIndifferentAccess.new(
                                           name: ::HashWithIndifferentAccess.new( description: 'Description content' ))
                                    )
      end

      it 'should create a new tag type when required' do
        config.set_meta_tag(:foo, :bar, 'baz')

        expect(config.meta_tags).to have_key(:foo)
        expect(config.meta_tags[:foo]).to have_key(:bar)
        expect(config.meta_tags[:foo]).to be_instance_of ::HashWithIndifferentAccess
        expect(config.meta_tags[:foo][:bar]).to eq('baz')
      end
    end

    describe '#remove_meta_tag' do
      let(:config) do
        c = Configuration.new
        c.meta_tags = {
            name: {
                description: 'content',
                other: 'content'
            },
            foo: {
                bar: 'baz'
            }
        }
        c
      end

      context 'when the type still has values left' do
        before do
          config.remove_meta_tag(:name, :other)
        end

        it 'should have removed the name' do
          expect(config.meta_tags[:name]).to_not have_key(:other)
        end

        it 'should still have the type' do
          expect(config.meta_tags).to have_key(:name)
        end
      end

      context 'when the type still has values left' do
        before do
          config.remove_meta_tag(:foo, :bar)
        end

        it 'should have removed the type' do
          expect(config.meta_tags).to_not have_key(:foo)
        end
      end
    end
  end
end
