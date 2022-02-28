RSpec.describe JSON::Pie::TopLevel do
  describe '.parse' do
    subject(:parse) { described_class.parse ActionController::Parameters.new params }

    context 'with single resource' do
      let(:params) do
        {
          data: {
            type: :user,
          },
        }
      end

      it { is_expected.to be_a User }
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
        expect(parse.map(&:class)).to match_array [User, User]
      end
    end
  end
end
