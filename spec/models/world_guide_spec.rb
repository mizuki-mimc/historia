require 'rails_helper'

RSpec.describe WorldGuide, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:story) { FactoryBot.create(:story, user: user) }
  let(:world_guide) { FactoryBot.build(:world_guide, story: story) }

  def attach_test_image(model, filename, content_type)
    model.image.attach(
      io: File.open(Rails.root.join("spec/fixtures/files/#{filename}")),
      filename: filename,
      content_type: content_type
    )
  end

  describe 'image attachment validations' do
    context 'when an image is attached' do
      it 'is valid with a valid JPEG image' do
        attach_test_image(world_guide, 'test_image.jpeg', 'image/jpeg')
        expect(world_guide).to be_valid
      end

      it 'is valid with a valid PNG image' do
        attach_test_image(world_guide, 'test_image.png', 'image/png')
        expect(world_guide).to be_valid
      end

      it 'is invalid with a non-image file (TXT)' do
        attach_test_image(world_guide, 'test.txt', 'text/plain')
        expect(world_guide).not_to be_valid
        expect(world_guide.errors[:image]).to include('のファイル形式はJPEGまたはPNGにしてください')
      end

      it 'is invalid with a file larger than 5MB' do
        attach_test_image(world_guide, 'large_image.jpeg', 'image/jpeg')
        expect(world_guide).not_to be_valid
        expect(world_guide.errors[:image]).to include('のファイルサイズは5MB以下にしてください')
      end
    end

    context 'when no image is attached' do
      it 'is valid without an image' do
        expect(world_guide).to be_valid
      end
    end
  end

  describe 'image destruction on world guide deletion' do
    let!(:world_guide_with_image) { FactoryBot.create(:world_guide, :with_image, story: story) }

    it 'deletes the attached image and its blob when the world guide is destroyed' do
      attachments_count_before = ActiveStorage::Attachment.count
      blobs_count_before = ActiveStorage::Blob.count

      world_guide_with_image.destroy

      expect(ActiveStorage::Attachment.count).to eq(attachments_count_before - 1)
      expect(ActiveStorage::Blob.count).to eq(blobs_count_before - 1)
    end
  end
end
