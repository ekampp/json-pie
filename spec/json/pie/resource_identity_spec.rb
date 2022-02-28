# frozen_string_literal: true

RSpec.describe JSON::Pie::ResourceIdentity do
  describe ".find_or_initialize" do
    subject(:find_or_initialize) { described_class.find_or_initialize(type: type, id: id, **options) }

    let(:options) { {} }
    let(:type) { :user }
    let(:id) { user.id }
    let(:user) { User.create! name: "User 1" }

    it { is_expected.to eql user }

    context "with missing ID" do
      let(:id) { nil }

      it { is_expected.not_to eql user }
      it { is_expected.not_to be_persisted }
    end

    context "with invalid type" do
      let(:type) { :invalid_class }

      it { expect { find_or_initialize }.to raise_error JSON::Pie::InvalidType }
    end

    context "with mapped type" do
      before { options[:type_map] = { author: :user } }

      let(:type) { :author }

      it { is_expected.to eql user }
    end
  end
end
