# frozen_string_literal: true

module VegetableStatusModule
  extend ActiveSupport::Concern

  def determine_vegetable_status(labels)
    vegetable_status = {}

    labels.each do |label|
      if label.downcase.include?('healthy')
        vegetable_status[:status] = '健康的な状態です'
      elsif label.downcase.include?('disease') || label.downcase.include?('pest')
        vegetable_status[:status] = '病気や害虫の影響を受けている可能性があります'
      elsif label.downcase.include?('ripe') || label.downcase.include?('harvest')
        vegetable_status[:status] = '収穫の時期に近づいています'
      elsif label.downcase.include?('dry') || label.downcase.include?('wilting') || label.downcase.include?('yellowing')
        vegetable_status[:status] = '水分不足の可能性があります。十分な水やりを行いましょう。'
      elsif label.downcase.include?('overripe') || label.downcase.include?('rotten')
        vegetable_status[:status] = '過熟や腐敗の可能性があります。早めに収穫しましょう。'
      elsif label.downcase.include?('underripe') || label.downcase.include?('immature')
        vegetable_status[:status] = '未熟な状態です。収穫の時期を待ちましょう。'
      elsif label.downcase.include?('flowering') || label.downcase.include?('blossom')
        vegetable_status[:status] = '花が咲いています。収穫の準備が進んでいます。'
      elsif label.downcase.include?('fruiting') || label.downcase.include?('bearing fruit')
        vegetable_status[:status] = '実がついています。収穫の時期です。'
      elsif label.downcase.include?('weed') || label.downcase.include?('grass')
        vegetable_status[:status] = '雑草が生えています。間引きや雑草取りを行いましょう。'
      elsif label.downcase.include?('insect') || label.downcase.include?('bug')
        vegetable_status[:status] = '害虫が見られます。害虫駆除を行いましょう。'
      elsif label.downcase.include?('drought') || label.downcase.include?('dry soil')
        vegetable_status[:status] = '干ばつの可能性があります。十分な水を与えましょう。'
      elsif label.downcase.include?('fungal') || label.downcase.include?('mold')
        vegetable_status[:status] = 'カビが生えています。風通しの良い環境を保ちましょう。'
      elsif label.downcase.include?('nutrient deficiency') || label.downcase.include?('yellow leaves')
        vegetable_status[:status] = '栄養不足の兆候が見られます。肥料を追加しましょう。'
      elsif label.downcase.include?('overwatering') || label.downcase.include?('waterlogged')
        vegetable_status[:status] = '過剰な水やりの影響が見られます。水はけを良くするために土を乾燥させましょう。'
      elsif label.downcase.include?('stunted growth') || label.downcase.include?('small size')
        vegetable_status[:status] = '成長が停滞しています。栄養不足や環境の問題が考えられます。'
      elsif label.downcase.include?('sunburn') || label.downcase.include?('burnt leaves')
        vegetable_status[:status] = '日焼けが見られます。直射日光を避け、日陰に移動させましょう。'
      elsif label.downcase.include?('overgrown') || label.downcase.include?('too large')
        vegetable_status[:status] = '過剰成長しています。間引きを行いましょう。'
      elsif label.downcase.include?('undergrown') || label.downcase.include?('too small')
        vegetable_status[:status] = '成長が遅れています。十分な日光や栄養を与えましょう。'
      elsif label.downcase.include?('viral infection') || label.downcase.include?('virus')
        vegetable_status[:status] = 'ウイルス感染の兆候が見られます。感染した植物を早めに隔離しましょう。'
      elsif label.downcase.include?('inappropriate temperature') || label.downcase.include?('temperature stress')
        vegetable_status[:status] = '温度が適切でない可能性があります。適切な温度設定を確認しましょう。'
      else
        vegetable_status[:status] = 'その他の状態です。詳細を確認してください。'
      end
    end

    vegetable_status
  end
end
