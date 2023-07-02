# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

FavoriteSoccerActivity.create(soccer_type: '試合')
FavoriteSoccerActivity.create(soccer_type: '鳥かご')
FavoriteSoccerActivity.create(soccer_type: '対面パス')
FavoriteSoccerActivity.create(soccer_type: 'リフティング')
FavoriteSoccerActivity.create(soccer_type: '一対一')
FavoriteSoccerActivity.create(soccer_type: 'サッカーテニス')

SoccerEquipment.create(name: 'ボール')
SoccerEquipment.create(name: 'スパイク')
SoccerEquipment.create(name: 'トレーニングシューズ')
SoccerEquipment.create(name: 'レガース')
SoccerEquipment.create(name: 'マーカー')
SoccerEquipment.create(name: 'ビブス')

User.create(
  email: 'admin@example.com',
  password: 'adminpassword',
  password_confirmation: 'adminpassword',
  role: 1
)