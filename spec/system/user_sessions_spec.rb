require 'rails_helper'

RSpec.describe 'ユーザーログイン機能', type: :system do
  let(:user) { FactoryBot.create(:user) }

  describe 'ログイン前' do
    context 'フォームの入力値が正しい場合' do
      it 'ログインができて、トップページに移動する' do
        visit login_path
        expect(current_path).to eq(login_path)
        expect(page).to have_content('ログイン')
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        expect(current_path).to eq(root_path)
      end
    end

    context 'フォームが未入力の場合' do
      it 'ログインができず、ログイン画面に戻ってくる' do
        visit login_path
        expect(current_path).to eq(login_path)
        expect(page).to have_content('ログイン')
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        click_button 'ログイン'
        expect(current_path).to eq(login_path)
      end
    end
  end

  describe 'ログイン後' do
    before do
      login(user)
    end

    context 'ログアウトボタンを押した場合' do
      it 'ログアウトができて、ログイン画面に移動する' do
        pending 'この先BallMateをクリックできないので、保留'
        click_on 'BallMate'
        click_button 'ログアウト'
        expect(page.accept_confirm).to eq '本当にログアウトしますか？'
        expect(page).to have_content('ログアウトしました')
        expect(current_path).to eq(login_path)
      end
    end
  end
end