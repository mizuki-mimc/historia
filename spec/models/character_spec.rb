require 'rails_helper'

RSpec.describe Character, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:story) { FactoryBot.create(:story, user: user) }
  let(:character) { FactoryBot.build(:character, story: story) }

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
        attach_test_image(character, 'test_image.jpeg', 'image/jpeg')
        expect(character).to be_valid
      end

      it 'is valid with a valid PNG image' do
        attach_test_image(character, 'test_image.png', 'image/png')
        expect(character).to be_valid
      end

      it 'is invalid with a non-image file (TXT)' do
        attach_test_image(character, 'test.txt', 'text/plain')
        expect(character).not_to be_valid
        expect(character.errors[:image]).to include('のファイル形式はJPEGまたはPNGにしてください')
      end

      it 'is invalid with a file larger than 5MB' do
        attach_test_image(character, 'large_image.jpeg', 'image/jpeg')
        expect(character).not_to be_valid
        expect(character.errors[:image]).to include('のファイルサイズは5MB以下にしてください')
      end
    end

    context 'when no image is attached' do
      it 'is valid without an image' do
        expect(character).to be_valid
      end
    end
  end

  describe 'image destruction on character deletion' do
    let!(:character_with_image) { FactoryBot.create(:character, :with_image, story: story) }

    it 'deletes the attached image and its blob when the character is destroyed' do
      attachments_count_before = ActiveStorage::Attachment.count
      blobs_count_before = ActiveStorage::Blob.count

      character_with_image.destroy

      expect(ActiveStorage::Attachment.count).to eq(attachments_count_before - 1)
      expect(ActiveStorage::Blob.count).to eq(blobs_count_before - 1)
    end
  end
end
