class WorldGuide < ApplicationRecord
  belongs_to :story, touch: true
  has_many :world_guide_features, dependent: :destroy
  has_many :world_feature_categories, through: :world_guide_features
  has_many :plot_world_guides, dependent: :destroy
  has_many :plots, through: :plot_world_guides
  has_many :birthplace_characters, class_name: "Character", foreign_key: "birthplace_world_guide_id", dependent: :nullify
  has_many :address_characters, class_name: "Character", foreign_key: "address_world_guide_id", dependent: :nullify
  accepts_nested_attributes_for :world_guide_features, allow_destroy: true, reject_if: :all_blank

  has_one_attached :image, dependent: :destroy
  validates :image, content_type: { in: [ "image/jpeg", "image/png" ], message: "のファイル形式はJPEGまたはPNGにしてください" },
                    size: { less_than: 5.megabytes, message: "のファイルサイズは5MB以下にしてください" }

  after_save :process_image_variants, if: -> { image.attached? && image.changed? }
  before_destroy :purge_image

  enum category: {
    "現在" => "現在",
    "未来" => "未来",
    "過去" => "過去",
    "空想" => "空想"
  }

  def category_with_display_name
    "#{category} : #{country_and_region}"
  end

  def country_and_region
    [ country_name, region_name ].compact.reject(&:blank?).join(" / ")
  end

  validates :world_name, length: { maximum: 20 }
  validates :country_name, presence: true, length: { maximum: 20 }
  validates :region_name, presence: true, length: { maximum: 20 }

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
