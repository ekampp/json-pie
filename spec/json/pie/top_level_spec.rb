RSpec.describe JSON::Pie::TopLevel do
  describe '.parse' do
    subject(:resource) { described_class.parse ActionController::Parameters.new params }

    context 'with single resource' do
      let(:params) do
        {
          data: {
            type: :user,
            relationships: {
              articles: {
                data: [
                  {
                    type: :article,
                  },
                  {
                    type: :article,
                  },
                ],
              },
            },
          },
        }
      end

      it { is_expected.to be_a User }

      it 'assigns relationships' do
        expect(resource.articles.length).to be 2
      end
    end

    context 'with list of resources' do
      let(:params) do
        {
          data: [
            {
              type: :user,
            },
            {
              type: :user,
            },
          ],
        }
      end

      it 'returns a list of resources' do
        expect(resource.map(&:class)).to match_array [User, User]
      end
    end
  end
end
