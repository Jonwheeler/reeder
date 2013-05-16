class Feed < ActiveRecord::Base
  attr_accessible :title, :description, :url, :site_url, :last_modified_at

  has_many :posts, dependent: :destroy

  validates :title, presence: true
  validates :url,   presence: true, uniqueness: true

  scope :recent, order('last_modified_at DESC')

  after_commit :sync_posts, on: :create

  def sync_posts
    FeedWorker.perform_async(self.id)
  end

  def self.import(url)
    FeedImport.new(url).run
  end
end