class FeedPresenter < Presenter
  attribute :id, :title, :description
  attribute :url, :site_url
  attribute :last_modified_at, :status
  attribute :created_at, :updated_at
end