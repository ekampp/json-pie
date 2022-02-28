RSpec.describe JSON::Pie::ResourceObject do
  subject { described_class.parse data_object }

  let(:data_object) do
    {
      type: :user,
      id: 1,
    }
  end

  its(:instance) { is_expected.to be_a Object }
end
