# frozen_string_literal: true

require 'oxml'

RSpec.describe OXML::Utils do
  describe '.snakecase' do
    context 'when input is a String' do
      let(:input) { 'queryResponse' }
      let(:result) { 'query_response' }

      it { expect(described_class.snakecase(input)).to eq(result) }
    end

    context 'when input has namespace' do
      let(:input) { 'wd-dir5:queryResponse' }
      let(:result) { 'wd_dir5:query_response' }

      it { expect(described_class.snakecase(input)).to eq(result) }
    end

    context 'when input is nil' do
      it { expect(described_class.snakecase(nil)).to be_nil }
    end

    context 'when input is not a String' do
      let(:input) { :symbol }

      it { expect(described_class.snakecase(input)).to eq(input) }
    end
  end

  describe '.camelize' do
    context 'when input is a String' do
      let(:input) { 'query_response' }
      let(:result) { 'queryResponse' }

      it { expect(described_class.camelize(input)).to eq(result) }
    end

    context 'when input is nil' do
      let(:result) { '' }

      it { expect(described_class.camelize(nil)).to eq(result) }
    end

    context 'when input is empty string' do
      let(:input) { '' }
      let(:result) { '' }

      it { expect(described_class.camelize(input)).to eq(result) }
    end
  end
end
