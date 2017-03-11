require 'spec_helper'

RSpec.describe Apirosreestr::Api do
  let(:token) { 'DFJ3-B4SN-D9BN-LPEA' }
  let(:endpoint) { 'cadaster/search' }
  let(:api) { described_class.new(token) }

  describe '#call' do
    subject(:api_call) { api.call(endpoint, {query: 'Курск, Косухина 38, кв 19'}) }

    it 'returns hash' do
      is_expected.to be_a(Hash)
    end

    it 'has objects' do
      is_expected.to have_key('objects')
    end

    it 'has found' do
      is_expected.to have_key('found')
    end

    context 'when token is invalid' do
      let(:token) { '123456:wrongtoken' }

      it 'raises an error' do
        expect { api_call }
          .to raise_error(Apirosreestr::Exceptions::ResponseError)
      end
    end
  end

end
