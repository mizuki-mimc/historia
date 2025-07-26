require 'rails_helper'

RSpec.describe "Plot Template Functionality", type: :system do
  let!(:user) { create(:user) }
  let!(:story) { create(:story, user: user) }

  let!(:template_kisyotenketsu) do
    create(:plot_template,
           name: "⓵ 起承転結 ※バランス重視の王道構成",
           body: <<~TEXT
             ■ 起
             話・章の始まりとなる導入部です。登場人物、舞台、背景などを提示し、物語が動き出すきっかけを描きましょう。
             ※ 読者が世界にスムーズに入り込めるよう、情報量と感情の導入に配慮しましょう。
             （例：主人公が偶然、不思議なアイテムを手に入れる）

             ・流れを伏線（フラグ）などを踏まえて箇条書きで簡単にまとめましょう。
             ・

             ■ 承
             起（導入）で提示された要素が発展していく展開部です。事件や出会い、選択が積み重なり、物語の軸が形成しましょう。
             ※ 読者の興味を保ちながら、世界や人物関係をさらに深掘りしましょう。

             ・流れを伏線（フラグ）などを踏まえて箇条書きで簡単にまとめましょう。
             ・

             ■ 転
             話・章が大きく転換し、クライマックスへ向かう転機です。価値観を揺るがす出来事や意外な展開が描かれ、緊張感を高めましょう。
             ※ 読者の予想を良い意味で裏切る「展開の跳ね」を意識しましょう。
             （例：アイテムを狙う敵が現れ、主人公が窮地に陥る）

             ・流れを伏線（フラグ）などを踏まえて箇度書きで簡単にまとめましょう。
             ・

             ■ 結
             話・章をまとめる結末です。すべての因果を収束させ、読者に納得と余韻を与えましょう。
             ※ 感情のカタルシスや、テーマの回収を意識すると印象的な終わりになります。
             （例：主人公が知恵と勇気で敵を倒し、平穏な日常を取り戻す）

             ・流れを伏線（フラグ）などを踏まえて箇条書きで簡単にまとめましょう。
             ・

           TEXT
          )
  end
  let!(:template_simple) do
    create(:plot_template,
           name: "⓶ 序破急 ※テンポとスピード感重視",
           body: <<~TEXT
             ■ 序 （静）
             静かな導入部を意識しましょう。話・章の背景や状況、舞台設定、登場人物を丁寧に提示し、ゆっくりと始まるイメージです。
             ※ 大切なのは緩急です。余白や嵐の前の静けさを大切にしましょう。
             （例：平和な村で、主人公が日々の仕事や人々とのやりとりをしながら暮らしている。）

             ・流れを伏線（フラグ）などを踏まえて箇条書きで簡単にまとめましょう。
             ・

             ■ 破 （動）
             話・章が急に大きく動き出す展開部です。「序」で築かれた静寂を破り、事件や対立が発生します。
             ※ 大切なのはスピード感です。序との緩急をつけることで緊張感を生み出しましょう。
             （例：村に脅威が訪れ、主人公が旅立ちを決意する）

             ・流れを伏線（フラグ）などを踏まえて箇条書きで簡単にまとめましょう。
             ・

             ■ 急 （急加速）
             物語がクライマックスを迎え、一気に結末へと向かう部分。テンポが速く、激しい展開が続きます。
             ※ スピード感を意識して、テンポよくまとめましょう。
             （例：最終決戦を経て、物語が大団円を迎える）

             ・流れを伏線（フラグ）などを踏まえて箇条書きで簡単にまとめましょう。
             ・

           TEXT
          )
  end

  before do
    driven_by(:selenium_chrome_headless)

    mock_auth_for(user)

    visit root_path
    expect(page).to have_button("Googleでログイン")

    within(".action-buttons") do
      click_button "Googleでログイン"
    end

    expect(page).to have_current_path(stories_path)

    visit new_story_plot_path(story)
    expect(page).to have_css('h1', text: 'プロットを作成しよう！')
  end

  describe "プロットテンプレートの選択と「末尾に挿入」ボタンの動作" do
    context "構成メモのテキストエリアが空の場合" do
      it "ドロップダウンからテンプレートを選択し、内容が正しく反映されること" do
        expect(find_field('plot_content').value).to be_blank

        expect(page).to have_select('plot_template', selected: 'テンプレートを選択 ※未選択でも可')

        select template_kisyotenketsu.name, from: 'plot_template'

        click_button '末尾に挿入'

        expect(find_field('plot_content').value).to eq("#{template_kisyotenketsu.body}\n")
      end
    end

    context "構成メモのテキストエリアに既存の入力がある場合" do
      let(:existing_text) { "これは既存のプロットメモです。\n\n" }

      before do
        fill_in 'plot_content', with: existing_text
        expect(find_field('plot_content').value).to eq(existing_text)
      end

      it "ドロップダウンからテンプレートを選択し、既存のテキストの末尾に内容が挿入されること" do
        select template_simple.name, from: 'plot_template'

        click_button '末尾に挿入'

        expected_content = existing_text + template_simple.body + "\n"
        expect(find_field('plot_content').value).to eq(expected_content)
      end
    end
  end
end
