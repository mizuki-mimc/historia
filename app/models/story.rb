class Story < ApplicationRecord
  attribute :status, :integer, default: 0
  belongs_to :user
  has_many :plots, dependent: :destroy
  has_many :world_guides, dependent: :destroy
  has_many :flags, dependent: :destroy
  has_many :plot_flags, through: :plots
  has_many :characters, dependent: :destroy
  has_many :character_features, through: :characters
  has_many :world_guide_features, through: :world_guides
  has_many :character_relationships, through: :characters, source: :relationships

  enum status: { draft: 0, published: 1 }

  enum genre: {
    fantasy: "ファンタジー",
    sf: "SF",
    romance: "恋愛",
    mystery: "ミステリー",
    horror: "ホラー",
    history: "歴史",
    contemporary: "現代小説",
    other: "その他"
  }

  validates :title, presence: true, length: { maximum: 100 }
  validates :genre, presence: true
  validates :thema, length: { maximum: 50 }
  validates :synopsis, length: { maximum: 500 }

  def self.ransackable_attributes(auth_object = nil)
    ["title", "thema", "synopsis", "genre", "status", "created_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["characters", "user", "plots", "world_guides", "flags"] 
  end
end
