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
                    attributes: {
                      name: "A1",
                    }
                  },
                  {
                    type: :article,
                    attributes: {
                      name: "A2",
                    }
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

      it 'assigns relationship attributes' do
        expect(resource.articles.map(&:name)).to match_array %w[A1 A2]
      end
    end

    context 'with list of resources' do
      let(:params) do
        {
          data: [
            {
              type: :user,
              attributes: {
                name: "U1"
              }
            },
            {
              type: :user,
              attributes: {
                name: "U2"
              }
            },
          ],
        }
      end

      it 'returns a list of resources' do
        expect(resource.map(&:class)).to match_array [User, User]
      end

      it 'assigns attributes to the resources' do
        expect(resource.map(&:name)).to match_array %w[U1 U2]
      end
    end
  end
end
