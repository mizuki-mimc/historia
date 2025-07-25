puts 'Recreating World Feature Categories...'

WorldFeatureCategory.destroy_all

feature_categories = [ "建物", "乗り物", "服飾", "貨幣", "食べ物", "言語", "宗教", "外交", "政治", "歴史", "天候", "特産品", "民族", "文化", "技術", "その他" ]
feature_categories.each do |cat_name|
  WorldFeatureCategory.create!(name: cat_name)
end

puts '...World Feature Categories recreated!'

puts 'Creating Character Feature Categories...'

CharacterFeatureCategory.destroy_all

character_feature_categories = [ "性格", "身長", "体重", "髪型", "髪色", "目の色", "肌の色", "武器", "思想", "宗教", "能力", "特技", "服装", "言語", "癖", "その他" ]
character_feature_categories.each do |cat_name|
  CharacterFeatureCategory.create!(name: cat_name)
end

puts '...Character Feature Categories created!'

puts 'プロットテンプレートの初期データを作成します...'

PlotTemplate.find_or_create_by!(name: '⓵ 起承転結 ※バランス重視の王道構成') do |template|
  template.description = '物語の基本的な構成単位。導入、展開、転換、結末の4つの部分から成ります。'
  template.body = <<~TEXT
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

    ・流れを伏線（フラグ）などを踏まえて箇条書きで簡単にまとめましょう。
    ・

    ■ 結
    話・章をまとめる結末です。すべての因果を収束させ、読者に納得と余韻を与えましょう。
    ※ 感情のカタルシスや、テーマの回収を意識すると印象的な終わりになります。
    （例：主人公が知恵と勇気で敵を倒し、平穏な日常を取り戻す）

    ・流れを伏線（フラグ）などを踏まえて箇条書きで簡単にまとめましょう。
    ・
  TEXT
end

PlotTemplate.find_or_create_by!(name: '⓶ 序破急 ※テンポとスピード感重視') do |template|
  template.description = '日本の伝統芸能、特に能楽で用いられる構成。物事の始まり、展開、そしてクライマックスを表します。'
  template.body = <<~TEXT
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
end

PlotTemplate.find_or_create_by!(name: '⓷ 三幕構成 ※葛藤と成長を重視') do |template|
  template.description = '映画脚本などで広く用いられる構成。設定、対立、解決の3つの幕（アクト）で物語を構築します。'
  template.body = <<~TEXT
    ■ 第一幕（Act1）：設定、導入
    話・章の世界観、主要な登場人物、そして主人公が達成すべき目標や解決すべき問題を提示しましょう。
    この幕では、物語を動かす「きっかけ（インシディング・インシデント）」を起こしましょう。
    （例：平凡な青年が、故郷である王国を奪われ王国を救うという使命を与えられる）

    ・流れを伏線（フラグ）などを踏まえて箇条書きで簡単にまとめましょう。
    ・

    ■ 第二幕（Act2）：成長、葛藤
    話・章の中心部分かつ最も長くなる部分。提示した目標達成、問題解決のために様々な障害や困難に直面し、葛藤を描きましょう。
    ※ 物語の折り返し地点（ミッドポイント）で、状況が大きく変化することが多いです。
    （例：王国を救うための仲間と出会い、数々の試練を乗り越え、敵の本境地に近づいていく）

    ・流れを伏線（フラグ）などを踏まえて箇条書きで簡単にまとめましょう。
    ・

    ■ 第三幕（Act3）：クライマックス、解決
    話・章のクライマックスです。主人公は最大の障害（ラスボス）と対峙し、第一幕で提示した目標や問題が解決に向かいます。
    伏線（フラグ）の多くがここで回収され、物語は完結へと向かいます。
    ※ 次回への伏線（フラグ）設置も行うと読者の興味維持につながります。
    （例：最終決戦で魔王を倒し、王国に平和が戻る。主人公は王国の英雄となる）

    ・流れを伏線（フラグ）などを踏まえて箇条書きで簡単にまとめましょう。
    ・
  TEXT
end

puts 'プロットテンプレートの作成が完了しました！'
