json.array!(@articles) do |article|
  json.extract! article, :id, :url, :title, :heading, :content, :image, :tags, :provider, :status, :user_id
  json.url article_url(article, format: :json)
end
