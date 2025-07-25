class Character < ApplicationRecord
  belongs_to :story, touch: true
  belongs_to :birthplace_world_guide, class_name: "WorldGuide", optional: true
  belongs_to :address_world_guide, class_name: "WorldGuide", optional: true

  has_one_attached :image, dependent: :destroy
  validates :image, content_type: { in: [ "image/jpeg", "image/png" ], message: "のファイル形式はJPEGまたはPNGにしてください" },
                    size: { less_than: 5.megabytes, message: "のファイルサイズは5MB以下にしてください" }

  after_save :process_image_variants, if: -> { image.attached? && image.changed? }
  before_destroy :purge_image

  has_many :character_features, dependent: :destroy
  has_many :character_feature_categories, through: :character_features
  accepts_nested_attributes_for :character_features, allow_destroy: true, reject_if: :all_blank

  has_many :relationships, class_name: "CharacterRelationship", foreign_key: "character_id", dependent: :destroy, inverse_of: :character
  has_many :related_characters, through: :relationships, source: :related_character

  has_many :reverse_of_relationships, class_name: "CharacterRelationship", foreign_key: "related_character_id", dependent: :destroy
  has_many :relating_characters, through: :reverse_of_relationships, source: :character
  accepts_nested_attributes_for :relationships, allow_destroy: true, reject_if: proc { |attributes| attributes["relationship_type"].blank? }

  has_many :plot_characters, dependent: :destroy
  has_many :plots, through: :plot_characters

  enum category: {
    "現在" => "現在",
    "未来" => "未来",
    "過去" => "過去",
    "空想" => "空想"
  }

  enum gender: {
    male: 0,
    female: 1,
    other: 2,
    unknown: 99
  }

  validates :name, presence: true, length: { maximum: 30 }
  validates :race, length: { maximum: 30 }
  validates :age, length: { maximum: 20 }

  private

  def process_image_variants
    image.variant(resize_to_limit: [ 1200, 1200 ]).processed
    image.variant(resize_to_limit: [ 800, 800 ]).processed
    image.variant(resize_to_fill: [ 128, 128 ]).processed
  end

  def purge_image
    image.purge
  end
end
