require 'spec_helper'

describe ContentNetwork::EntriesFetcher do
  let(:api_endpoint_entry) { 'http://local.content-network.dev/zapi/v1/' }
  let(:total_specials) { 2 }
  let(:total_editions) { 8 }
  let(:limit) { 2 }

  before do
    ContentNetwork.base_uri api_endpoint_entry
  end

  let(:fetcher) { ContentNetwork::EntriesFetcher.new(params, pagination_params) }
  let(:pagination_params) { {} }

  context 'when editions params' do
    subject(:collection) { VCR.use_cassette('fetch_editions') { fetcher.fetch } }

    let(:params) {
      {
        element_type: 'Entry',
        section_name: 'ondeck',
        entry_type: 'ondeckEdition'
      }
    }

    its(:error?) { should be false }

    context 'its pagination' do
      subject(:pagination) { collection.pagination }
      specify { expect(pagination['count']).to eq limit }
      specify { expect(pagination['total']).to eq total_editions }
      specify { expect(pagination['current_page']).to eq 1 }
    end

    context 'its data' do
      subject(:data) { collection.data }
      it { should be_an_instance_of Array }
      its(:size) { should eq limit }

      context 'the editions' do
        let(:edition_ids) { data.map { |edition| edition['id'] } }
        specify { expect(edition_ids).to eq ['256', '104'] }
      end
    end

    context 'when paginating' do
      subject(:collection) { VCR.use_cassette('fetch_editions_with_pagination') { fetcher.fetch } }

      let(:pagination_params) { { page: 2 } }

      context 'its pagination' do
        subject(:pagination) { collection.pagination }
        specify { expect(pagination['count']).to eq limit }
        specify { expect(pagination['total']).to eq total_editions }
        specify { expect(pagination['current_page']).to eq 2 }
      end

      context 'its data' do
        subject(:data) { collection.data }
        it { should be_an_instance_of Array }
        its(:size) { should eq limit }

        context 'the editions' do
          let(:edition_ids) { data.map { |edition| edition['id'] } }
          specify { expect(edition_ids).to eq ['95', '92'] }
        end
      end
    end
  end

  context 'when specials params' do
    subject(:collection) { VCR.use_cassette('fetch_specials') { fetcher.fetch } }

    let(:params) {
      {
        element_type: 'Entry',
        section_name: 'ondeck',
        entry_type: 'ondeckSpecial'
      }
    }

    its(:error?) { should be false }

    context 'its data' do
      subject(:data) { collection.data }
      it { should be_an_instance_of Array }
      its(:size) { should eq total_specials }
    end
  end

  context 'when content network down' do
    subject(:collection) { VCR.use_cassette('fetch_down') { fetcher.fetch } }

    let(:params) {
      {
        element_type: 'Entry',
        section_name: 'ondeck',
        entry_type: 'ondeckSpecial'
      }
    }

    its(:error?) { should be true }
    its(:error) { should match /unexpected token/ }
    its(:data) { should be nil }
  end
end
