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
  it { expect(instance).to be_persisted }
  it { expect(instance.name).to eql "New name" }

  context 'without ID' do
    before { data_object.delete :id }
    it { is_expected.not_to eql user }
    it { is_expected.to be_a User }
    it { expect(instance).not_to be_persisted }
  end

  context 'without type' do
    before { data_object.delete :type }
    it { expect { instance }.to raise_error JSON::Pie::MissingType }
  end

  context 'with invalid type' do
    before { data_object[:type] = :invalid_class }
    it { expect { instance }.to raise_error JSON::Pie::InvalidType }
  end

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
