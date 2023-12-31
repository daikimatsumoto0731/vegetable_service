# vegetable_service

## サービスコンセプト
* ユーザーが抱えている課題感と提供するサービスでどのように解決するのか
→家庭菜園で無農薬野菜を作るのが難しいと感じている人が多いと思ったので、
それをスケジュール管理やアドバイスをして初心者でも簡単に無農薬野菜を作れるサービスにする。

* なぜそのサービスを作ろうと思ったのか
家で野菜を作ったことがあり、自分で収穫してそれを食べることによって達成感を感じれたことと同時に
野菜を作ることがいかに大変さを知ることができたから。

最近は気候変動などによって、野菜も高くなっているし、
フードロストも問題になっているので自分で作ることによって、
節約とフードロスの削減につながると思ったから。
* どのようなサービスにしていきたいか
初心者でも簡単に無農薬野菜を作れるようなサービスにする。
* どこが売りになるか、差別化ポイントになるか
→ただ野菜を作るのではなく、無農薬野菜を作り、
それを買った時と収穫した時での値段を比較できるようにする
→忘れがちな、毎日の水やりをLINEの通知で教えてくれる。

## 実装を予定している機能
### MVP
* 会員登録
* ログイン
* スケジュール管理
* 水やり通知機能(LINE)
* 買った野菜と育てた野菜を比較できる機能

### その後の機能(現段階で考えている)
* 天気情報を表示
* アドバイス機能
* OpenWeatherMap APIを使用予定

## 考えている使う技術
* Ruby(最新ver使用)
* Rails(v7系で実装)
* Deviseなどの認証 gem を使用
* LINEのAPIを使用
* JavaScript
* Chat GPT API
* Python


## 画面遷移図
https://www.figma.com/file/woDOrmHhrxtdRX12DIeaUk/runteq?type=design&node-id=11-2&mode=design&t=dmm76l53LGGcNAv3-0