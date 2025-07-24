class WorldGuideFeature < ApplicationRecord
  belongs_to :world_guide, touch: true
  belongs_to :world_feature_category

  has_one_attached :image, dependent: :destroy
  validates :image, content_type: { in: [ "image/jpeg", "image/png" ], message: "のファイル形式はJPEGまたはPNGにしてください" },
                    size: { less_than: 5.megabytes, message: "のファイルサイズは5MB以下にしてください" }

  after_save :process_image_variants, if: -> { image.attached? && image.changed? }
  before_destroy :purge_image

  validates :explanation, length: { maximum: 25 }

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
