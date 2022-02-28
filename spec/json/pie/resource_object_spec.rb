RSpec.describe JSON::Pie::ResourceObject do
  subject(:instance) { described_class.parse data_object }

  let(:user) { User.create! name: "User 1" }

  let(:data_object) do
    {
      type: :user,
      id: user.id,
    }
  end

  it { is_expected.to eql user }
  it { expect(instance).to be_persisted }

  context 'without ID' do
    before { data_object.delete :id }
    it { is_expected.not_to eql user }
    it { is_expected.to be_a User }
    it { expect(instance).not_to be_persisted }
  end
end
