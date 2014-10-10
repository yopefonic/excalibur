require 'spec_helper'

module Excalibur
  describe TruncateableContent do
    describe '#new' do
      let(:obj) { TruncateableContent.new }

      it 'should create default content hash' do
        expect(obj.content).to_not be_nil
        expect(obj.content).to be_instance_of ::HashWithIndifferentAccess
      end

      it 'should create default options hash' do
        expect(obj.options).to_not be_nil
        expect(obj.options).to be_instance_of ::HashWithIndifferentAccess
      end

      it 'should create a default combinator' do
        expect(obj.combinator).to be_nil
      end
    end

    describe '#can_merge?' do
      let(:obj) { TruncateableContent.new }

      context 'when the objects are not the same' do
        it 'should be false' do
          expect(obj.can_merge?(true)).to eq(false)
        end
      end

      context 'when the objects is the same' do
        it 'should be true' do
          expect(obj.can_merge?(obj)).to eq(true)
        end
      end
    end

    describe '#merge!' do
      context 'when trying to merge with the wrong type of object' do
        let(:obj) { TruncateableContent.new }

        it 'should raise a TypeError' do
          expect { obj.merge!('foo') }.to raise_error(TypeError, 'can only merge two Excalibur::TruncateableContent objects')
        end
      end

      context 'when merging two correct object types' do
        let(:obj_a) { TruncateableContent.new({body: 'foobar'}, {'body' => 'baz', other: true}, 'obj_a') }
        let(:obj_b) { TruncateableContent.new({'body' => 'baz', other: true}, {body: 'foobar'}, 'obj_b') }

        context 'function result' do
          it 'should return the object' do
            expect(obj_a.merge!(obj_b)).to be_instance_of TruncateableContent
          end
        end

        context 'instance result' do
          before do
            obj_a.merge!(obj_b)
          end

          it 'should merge the content' do
            expect(obj_a.content).to eq({'body' => 'baz', 'other' => true})
          end

          it 'should merge the options' do
            expect(obj_a.options).to eq({'body' => 'foobar', 'other' => true})
          end

          it 'should overwrite the combinator' do
            expect(obj_a.combinator).to eq('obj_b')
          end

          context 'when merging an object without combinator' do
            let(:obj_b) { TruncateableContent.new({'body' => 'baz', other: true}, {body: 'foobar'}) }

            it 'should not overwrite the combinator' do
              expect(obj_a.combinator).to eq('obj_a')
            end
          end
        end
      end
    end

    describe '#dup' do
      let(:obj) { TruncateableContent.new({body: 'foobar', other: proc { |obj| "proc content #{obj}" }}, {}, nil) }

      it 'should create a duplicate of the object and the attributes' do
        expect(obj).to receive(:dup_instance).exactly(3).times

        obj.dup
      end
    end

    describe '#get_content' do
      let(:obj) { TruncateableContent.new(body: 'foobar', other: proc { |obj| "proc content #{obj}" }) }

      it 'should return string content' do
        expect(obj.get_content(:body)).to be_instance_of ::String
        expect(obj.get_content(:body)).to eq('foobar')
      end

      it 'should return the result of proc content' do
        expect(obj.get_content(:other, true)).to be_instance_of ::String
        expect(obj.get_content(:other, true)).to eq('proc content true')
      end
    end

    describe '#update_content' do
      let(:obj) { TruncateableContent.new }

      context 'when value is provided' do
        it 'should add the content value' do
          expect { obj.update_content(:body, 'Body content') }.to change(obj, :content)
          expect(obj.content[:body]).to eq('Body content')
        end
      end

      context 'when value has not been provided' do
        it 'should add the content value' do
          obj.update_content(:body)

          expect(obj.content).to have_key(:body)
          expect(obj.content[:body]).to be_nil
        end
      end
    end

    describe '#update_option' do
      let(:obj) { TruncateableContent.new }

      context 'when value is provided' do
        it 'should add the option value' do
          expect { obj.update_option(:limit, 88) }.to change(obj, :options)
          expect(obj.options[:limit]).to eq(88)
        end
      end

      context 'when value has not been provided' do
        it 'should add the content value' do
          obj.update_option(:limit)

          expect(obj.options).to have_key(:limit)
          expect(obj.options[:limit]).to be_nil
        end
      end
    end

    describe '#update_combinator' do
      let(:obj) { TruncateableContent.new }

      it 'should set the combinator' do
        expect(obj.combinator).to be_nil

        expect{ obj.update_combinator(proc { 'foobar' }) }.to change(obj, :combinator)

        expect(obj.combinator).to be_instance_of(::Proc)
        expect(obj.combinator.call).to eq('foobar')
      end
    end

    describe '#render_long' do
      let(:obj) { TruncateableContent.new(body: 'foobar', other: proc { |obj| "proc content #{obj}" }) }

      it 'should render all the values of the content hash' do
        expect(obj.render_long(true)).to be_instance_of ::String
        expect(obj.render_long(true)).to eq('foobarproc content true')
      end
    end

    describe '#render_short' do
      context 'when a combinator is a proc' do
        let(:obj) { TruncateableContent.new({}, {}, proc { |obj| "obj: #{obj}" }) }

        it 'should call the proc with the given object' do
          expect(obj.render_short(true)).to eq('obj: true')
        end
      end

      context 'when a combinator is not a proc' do
        let(:obj) { TruncateableContent.new() }

        it 'should call for render_long' do
          expect(obj).to receive(:render_long).with(true)

          obj.render_short(true)
        end
      end
    end
  end
end
