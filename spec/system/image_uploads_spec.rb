require 'rails_helper'

RSpec.describe 'Image uploads', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:story) { FactoryBot.create(:story, user: user) }

  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: user.uid,
      info: { name: user.name, email: user.email }
    })

    visit root_path
    within(".action-buttons") do
      click_button 'Googleでログイン'
    end
    expect(page).to have_current_path(stories_path)
  end

  describe 'Character image upload' do
    it 'allows a user to upload and view an image for a new character' do
      visit new_story_character_path(story)

      fill_in 'キャラクター名', with: 'テストキャラクター'
      select '現在', from: 'カテゴリー'
      attach_file 'character[image]', Rails.root.join('spec/fixtures/files/test_image.jpeg'), make_visible: true
      click_button 'キャラクターを作成する'

      expect(page).to have_content('キャラクターを追加しました。')

      new_character = Character.last
      visit story_character_path(story, new_character)
      expect(page).to have_selector("img[src*='test_image.jpeg']")
    end

    it 'allows a user to update an image for an existing character' do
      character = FactoryBot.create(:character, :with_image, story: story)
      visit edit_story_character_path(story, character)

      expect(page).to have_selector("img[src*='test_image.jpeg']")
      attach_file 'character[image]', Rails.root.join('spec/fixtures/files/test_image.jpeg'), make_visible: true
      click_button 'キャラクターを更新する'

      expect(page).to have_content('キャラクターを更新しました。')
      expect(page).to have_selector("img[src*='test_image.jpeg']")
    end

    it 'displays validation errors for invalid image uploads' do
      visit new_story_character_path(story)

      fill_in 'キャラクター名', with: 'テストキャラクター'
      attach_file 'character[image]', Rails.root.join('spec/fixtures/files/test.txt'), make_visible: true
      click_button 'キャラクターを作成する'

      expect(page).to have_content('のファイル形式はJPEGまたはPNGにしてください')
    end

    it 'allows a user to remove an image from an existing character' do
      character = FactoryBot.create(:character, :with_image, story: story)
      visit edit_story_character_path(story, character)

      expect(page).to have_selector("img[src*='test_image.jpeg']")

      find('button[data-modal-confirm-event-name-param="remove-image"]').click
      click_button '削除する'
      click_button 'キャラクターを更新する'

      expect(page).to have_content('キャラクターを更新しました。')
      expect(page).to have_content('なし')
      character.reload
      expect(character.image.attached?).to be_falsey
    end

    it 'deletes the image when the character record is destroyed' do
      character = FactoryBot.create(:character, :with_image, story: story)
      visit story_character_path(story, character)

      click_link('キャラクターを削除')
      click_button '削除する'

      expect(page).to have_content('キャラクターを削除しました。')
      expect(page).to have_current_path(story_characters_path(story))
    end
  end

  describe 'WorldGuide image upload' do
    it 'allows a user to upload and view an image for a new world guide' do
      visit new_story_world_guide_path(story)

      fill_in '国名', with: 'テスト国'
      fill_in '地域名', with: 'テスト地域'
      attach_file 'world_guide[image]', Rails.root.join('spec/fixtures/files/test_image.jpeg'), make_visible: true
      click_button 'ワールドガイドを作成する'

      expect(page).to have_content('ワールドガイドを追加しました。')

      new_world_guide = WorldGuide.last
      visit story_world_guide_path(story, new_world_guide)
      expect(page).to have_selector("img[src*='test_image.jpeg']")
    end

    it 'deletes the image when the world guide record is destroyed' do
      world_guide = FactoryBot.create(:world_guide, :with_image, story: story)
      visit story_world_guide_path(story, world_guide)

      click_link('ワールドガイドを削除する')
      click_button '削除する'

      expect(page).to have_content('ワールドガイドを削除しました。')
      expect(page).to have_current_path(story_world_guides_path(story))
    end
  end
end
