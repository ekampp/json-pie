RSpec.describe JSON::Pie::ResourceRelationships do
  describe '.assign' do
    subject(:assign) { described_class.assign(**kwargs) }

    let(:kwargs) do
      {
        instance: instance,
        relationships: {
          articles: {
            data: [
              {
                type: :article,
                id: article.id,
              },
              {
                type: :article,
              },
            ],
          },
        },
      }
    end
    let(:instance) { User.create! name: "User 1" }
    let(:article) { Article.create! name: "Article 1" }

    it 'assigns the existing article' do
      assign
      expect(instance.articles).to include(article)
    end

    it 'assigns a new article' do
      assign
      expect(instance.articles.size).to be 2
    end
  end
end
