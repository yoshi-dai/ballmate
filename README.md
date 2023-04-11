■ サービス概要　
　気軽にサッカーを一緒にできるような友達を作りたいと思っている方に
　新しいサッカー仲間との出会いを提供する
　サッカー特化型マッチングサービス「BallMate」です。

　■メインのターゲットユーザー
　10〜30代の男性、サッカー好き。
　学生時代とは異なり、自由なサッカー交流や、コミュニティーがなく寂しく感じている。

　■ユーザーが抱える課題
　サッカーが好きでこれからも続けていきたいけど、いきなりのチーム参加は少し気が乗らないし、仮にチームに参加したとしても必要以上に時間を拘束されたくない。
かといって、1人で練習したり、個人参加型のサービスに参加するのもどこか寂しく感じている。

　■解決方法　
　面識のない人同士であっても、一緒にサッカーをすることに対する心理的ハードルを下げるための機能を持つマッチングサービスを提供することで、サッカーを通じた新たな出会いを見つけるきっかけを与える。
　
　■実装予定の機能
：未登録ユーザー（未ログインユーザー）
　・LPを閲覧できて、サービスの使い方ガイドのページ、新規登録ができる。
　　・LPを閲覧できる。
　　・サービスの使い方ガイドのページへ遷移できる。
　　・ユーザー情報を登録することで新規登録ができる。

：登録済みユーザー
　・ログインができる。
　　・ログイン画面に遷移できる。
　　・登録された情報を入力することでログインできる。
　・プロフィールの設定ができる。
　　・プロフィール設定画面に遷移できる。
　　・プロフィールの詳細設定ができる。
　・プロフィール未設定でも、登録ユーザーを閲覧できる。
　　・登録ユーザー一覧ページへ遷移できる。
	・ユーザーの条件を指定して検索できる。
　　・登録ユーザー一覧から詳細ページへ遷移できる。
　・プロフィール未設定でも、参加可能なマッチング(複数人可)を閲覧できる。
　　・マッチング一覧ページへ遷移できる。
　　・参加可能なマッチングの条件を指定して検索できる。
　　・マッチング一覧 から詳細ページへ遷移できる。
　・お知らせを確認することができる。
　　・お知らせ一覧を表示できる。
　　・お知らせの詳細を確認できる。

：プロフィール登録済みユーザー
　・気になるユーザーへチャットの許可申請を行うことができる。
　　・登録ユーザー一覧ページへ遷移できる。
	・ユーザーの条件を指定して検索できる。
　　・登録ユーザー一覧から詳細ページへ遷移できる。
　　　・チャットの許可申請をすることができる。
　・気になる参加可能なマッチングにチャットの許可申請を行うことができる。
　　・マッチング一覧ページへ遷移できる。
　　・参加可能なマッチングの条件を指定して検索できる。
　　・マッチング一覧 から詳細ページへ遷移できる。
　　　・チャットの許可申請をすることができる。
　
：チャットの許可申請中のユーザー
　・出している申請の管理ができる。
　　・マッチング申請中ユーザー一覧ページへ遷移できる。
　　・マッチング申請中ユーザーの詳細ページへ遷移できる。
	　・チャット許可申請を取り消せる。
　　・参加申請中のマッチング一覧ページへ遷移できる。
　　・参加申請中のマッチング詳細ページへ遷移できる。
　　　・チャットの許可申請を取り消せる。

：チャットの許可申請を受けているユーザー
　・受けている申請の管理ができる。
　　・マッチング申請を受けているユーザー一覧ページへ遷移できる。
　　　・マッチング申請を受けているユーザー詳細ページへ遷移できる。
　　　　・チャットの許可申請の承認、拒否ができる。
　　　・参加申請を受けているマッチング一覧ページへ遷移できる。
　　　・参加申請を受けているマッチング詳細ページへ遷移できる。
　　　　・参加申請をしてきているユーザー詳細ページへ遷移できる。
　　　　・チャットの許可申請の承認、拒否ができる。

：マッチング成立済みユーザー
　・自身の成立したマッチング一覧を閲覧できる。
　　・自身の成立したマッチング一覧へ遷移できる。
　・マッチングの詳細を設定することができる。
　　・マッチング詳細ページに遷移できる。
　　　・マッチング詳細を変更できる。

：管理ユーザー
　・ユーザーの管理が管理ができる。
    　・全ユーザーの検索、一覧、詳細、編集ができる。
　・マッチングの管理ができる。
　　・登録されているマッチングの検索、一覧、詳細、編集ができる。

*ユーザーが設定できるプロフィールの項目として、 (１好きなサッカー選手、２好きなサッカーチーム、３サッカーの経歴（未経験、経験あり、プロ、元プロ）、４好きなサッカーの監督、５好きなサッカーゲーム、６サッカーをプレーする際のポジション、７これまでのサッカーしてきたチームでの役割（例、下手くそだけと気持ちでチームを助けるプレーヤー、頭脳明晰な分析官タイプのプレーヤー、戦術が大好きなチームプレーヤー、全然守備しないファンタジスタタイプのプレーヤー、など）、８プロフィール写真、９年齢、１０お気に入りコート、公園、１１好きなサッカーの種目（例、試合、鳥籠、対面パス、リフティング、一対一、サッカーテニス、など）、１２活動範囲（県、市区町村）、１３サッカー装備（スパイク、マーカー、レガース、ボール、ビブス、など）、１４一言メッセージ、１５活動可能な曜日、時間帯)がある。
※ ユーザーが設定できるプロフィールの項目のうち、１、２、３、４、５、６、９、１０、１１、１２、１５の項目でユーザーの検索が可能。

*マッチング詳細に表示される項目として、（１マッチング相手の情報、２実施予定の内容、３実施予定の日時、４実施される場所の地図情報、５おすすめの実施場所、６実施される場所の天気情報、７マッチング相手とのチャット画面、８マッチングをキャンセルするためのボタンやリンク等、９このマッチングを参加可能なマッチングとしてマッチング一覧に登録するかのチェックボタン）がある。
※ マッチング詳細に表示される項目のうち、２、３、４、９は追加募集を行う際に一覧で表示させるために必要な項目であるため、マッチングしたユーザーが任意で設定が可能。


*チャット機能については、LINE Messaging APIを使用します。(余裕があれば、マッチングしたユーザー同士の活動範囲や好きなサッカーの種目、活動可能な曜日や時間帯などから、おすすめを提案してくれるボットを搭載したいため。)

*実施される場所の天気情報を表示する機能については、OpenWeatherMap APIを使って、向こう１週間の天気予報と、実施予定の日時の天気予報を表示する。

*おすすめの実施場所を表示する機能については、Places APIを利用して、マッチングしたユーザーにそれぞれが設定した活動範囲（県、市区町村）に基づいて、周辺の公園やサッカー施設を提案する。


　■なぜこのサービスを作りたいのか？
　自分自身がサッカーが大好きで、これまで友達と一緒に試合を行ったり公園でボールを蹴ったりしてきました。しかし大学を卒業した今、これからはそこまで自由な交流は行えなくなるのかと寂しく感じていました。（仕事の休日や働く場所の都合で。）
そこで、自分と同じように気軽に一緒にサッカーをしてくれるような友達が欲しいと思っている人同士でお互いの都合が合う人同士でマッチングできれば、みんなが楽しいサッカー生活を続けられて新たな交流が生まれるのではと考えました。

もちろんSNSやチーム参加や一緒に試合を観に行くためのマッチングサービスはあります。ですが自分自身にとって、すでに出来上がっているチームに知り合いのあてもなく飛び込むことや、チャットで少し会話したような人といきなり90分もある試合観戦に行くことは、ハードルが高いです。
そのため、そのような関係の一つ手前で、私と同じような思いを持つ人同士がサッカーボールを介して打ち解け合えるための足掛りとなるような気楽なマッチングサービスを自分で作りたいと考えました。

　■スケジュール
　企画〜技術調査：4/10〆切
　README〜ER図作成：4/16 〆切
　メイン機能実装：4/16 - 5/20
　β版をRUNTEQ内リリース（MVP）：5/20〆切
　本番リリース：5月末
