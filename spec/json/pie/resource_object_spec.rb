RSpec.describe JSON::Pie::ResourceObject do
  subject(:instance) { described_class.parse(data_object, **options) }

  let(:user) { User.create! name: "User 1" }
  let(:options) { {} }
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

  context 'with type_map option' do
    before do
      options[:type_map] = { author: :user }
      data_object[:type] = :author
    end

    it { is_expected.to eql user }
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

  context 'with array of data objects' do
    let(:data_object) do
      [
        {
          type: :user,
        },
        {
          type: :user,
          id: user.id,
        },
      ]
    end

    it 'includes the existing user' do
      expect(instance).to include(user)
    end

    it 'includes a new user' do
      expect(instance.collect(&:persisted?)).to match_array [true, false]
    end
  end
end
