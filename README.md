# JSON::Pie

Parse JSON:API data structures into Rails ActiveRecord structures.

![Tests](https://github.com/ekampp/json-pie/actions/workflows/tests.yml/badge.svg)
![Linting](https://github.com/ekampp/json-pie/actions/workflows/linting.yml/badge.svg)

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

### Decoupling from your models

It's fairly easy to decouple the publis JSON:API that you parse from the actual data structure beneath by using the options.

```ruby
JSON::Pie.parse(params, **options)
```

| option | description |
| ------ | ----------- |
| `type_map` | A hash that maps JSON:API types to the actual models in your system. E.g. `{ author: :user }` |
