# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# 野菜の作成または取得
basil = Vegetable.find_or_create_by(name: 'バジル')
carrot = Vegetable.find_or_create_by(name: 'にんじん')
tomato = Vegetable.find_or_create_by(name: 'トマト')

# バジルのイベントと説明を追加
Event.create(vegetable: basil, name: '種まき', start_date: Time.zone.today, end_date: Time.zone.today + 5.days,
             description: 'バジルの種をまき、成長の旅を始めます。')
Event.create(vegetable: basil, name: '発芽期間', start_date: Time.zone.today + 5.days, end_date: Time.zone.today + 25.days,
             description: '種が発芽し、小さな芽が顔を出します。')
Event.create(vegetable: basil, name: '間引き・雑草抜き・害虫駆除', start_date: Time.zone.today + 25.days, end_date: Time.zone.today + 65.days,
             description: '健康な成長を促すために間引きを行い、雑草や害虫を管理します。')
Event.create(vegetable: basil, name: '収穫期間', start_date: Time.zone.today + 65.days, end_date: Time.zone.today + 105.days,
             description: 'バジルが成熟し、収穫の時を迎えます。')

# にんじんのイベントと説明を追加
Event.create(vegetable: carrot, name: '種まき', start_date: Time.zone.today, end_date: Time.zone.today + 10.days,
             description: 'にんじんの種をまきます。地下で静かに成長を始めます。')
Event.create(vegetable: carrot, name: '発芽期間', start_date: Time.zone.today + 10.days, end_date: Time.zone.today + 40.days,
             description: 'にんじんが発芽し、緑の芽が土の表面に現れます。')
Event.create(vegetable: carrot, name: '間引き・雑草抜き・害虫駆除', start_date: Time.zone.today + 40.days,
             end_date: Time.zone.today + 90.days, description: '根の成長を助けるために、適切な間引きと雑草管理が必要です。')
Event.create(vegetable: carrot, name: '収穫期間', start_date: Time.zone.today + 90.days, end_date: Time.zone.today + 170.days,
             description: 'にんじんが成長し、土から引き抜かれる準備が整います。')

# トマトのイベントと説明を追加
Event.create(vegetable: tomato, name: '種まき', start_date: Time.zone.today, end_date: Time.zone.today + 5.days,
             description: 'トマトの種をまき、新しい生命を育てます。')
Event.create(vegetable: tomato, name: '発芽期間', start_date: Time.zone.today + 5.days, end_date: Time.zone.today + 35.days,
             description: '温かい土の中でトマトの種が発芽します。')
Event.create(vegetable: tomato, name: '間引き・雑草抜き・害虫駆除', start_date: Time.zone.today + 35.days,
             end_date: Time.zone.today + 95.days, description: 'トマトの苗を健康に保つために、間引きと雑草の抜き取り、害虫の駆除が行われます。')
Event.create(vegetable: tomato, name: '収穫期間', start_date: Time.zone.today + 95.days, end_date: Time.zone.today + 175.days,
             description: 'トマトが赤く熟し、美味しい収穫を迎えます。')
