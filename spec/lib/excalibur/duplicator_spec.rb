require 'spec_helper'

module Excalibur
  class Foo; include Duplicator; end

  describe Duplicator do
    let(:klass) { Foo.new }

    describe '#dup_instance' do
      context 'when input is a truncable content' do
        let(:obj) { TruncateableContent.new }

        it 'should call dup' do
          expect( obj ).to receive(:dup)

          klass.dup_instance(obj)
        end
      end

      context 'when input is a hash' do
        let(:obj) { ::HashWithIndifferentAccess.new }

        it 'should call dup' do
          expect( obj ).to receive(:deep_dup)

          klass.dup_instance(obj)
        end
      end

      context 'when input is a string' do
        let(:obj) { 'foobar' }

        it 'should not call dup' do
          expect( obj ).to_not receive(:dup)

          expect(klass.dup_instance(obj)).to eq('foobar')
        end
      end

      context 'when input is nil' do
        let(:obj) { nil }

        it 'should not call dup' do
          expect(klass.dup_instance(obj)).to be_nil
        end
      end
    end
  end
end
