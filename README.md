# JSON::Pie

Parse JSON:API data structures into Rails ActiveRecord structures.

## Installation

```
gem "json-pie"
```

## Usage

Your models:

```ruby
class User < ActiveRecord::Base
  has_many :articles
end

class Article < ActiveRecord::Base
  belongs_to :user
end
```

In your controller:

```ruby
class ArticleController
  def create
    article = JSON::Pie.parse params
    article.save!
    render json: article, status: :created
  end
end
```

Then send this JSON structure to your application will create a new article with `#<User @id=1 ...>` as the author.

```json
{
  "data": {
    "type": "article",
    "attributes": {
      "title": "New article"
    },
    "relationships": {
      "user": {
        "data": {
          "type": "user",
          "id": 1
        }
      }
    }
  }
}
```
