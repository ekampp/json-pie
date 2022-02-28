RSpec.describe JSON::Pie::ResourceObject do
  subject(:instance) { described_class.parse data_object }

  let(:user) { User.create! name: "User 1" }

  let(:data_object) do
    {
      type: :user,
      id: user.id,
      attributes: {
        name: "New name",
      },
    }
  end

  it { is_expected.to eql user }
  it { expect(instance.name).to eql "New name" }
  it { expect { instance }.not_to change(user.reload, :name) }

  context 'with no attributes' do
    before { data_object.delete :attributes }
    it { is_expected.to eql user }
    it { expect(instance.name).to eql "User 1" }
  end

  context 'with invalid attributes' do
    before { data_object[:attributes] = { invalid_column: "value" } }
    it { expect { instance }.to raise_error JSON::Pie::InvalidAttribute }
  end
end
