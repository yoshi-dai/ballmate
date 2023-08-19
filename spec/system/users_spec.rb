require 'rails_helper'

RSpec.describe 'ユーザー', type: :system do
  let(:user) { create(:user) }

  describe 'ユーザー新規登録機能' do
    context '正しく情報を入力する' do
      it 'ユーザー新規登録ができ、ユーザープロフィール登録画面に移動する' do
        visit new_user_path
        expect(current_path).to eq(new_user_path)
        expect(page).to have_content('ユーザー登録')
        fill_in 'メールアドレス', with: 'email@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード確認', with: 'password'
        click_button '登録'
        expect(current_path).to eq(new_user_profile_path)
      end
    end

    context 'フォームが未入力' do
      it 'ユーザー新規登録ができず、ユーザー登録画面に遷移する' do
        visit new_user_path
        expect(current_path).to eq(new_user_path)
        expect(page).to have_content('ユーザー登録')
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        fill_in 'パスワード確認', with: ''
        click_button '登録'
        expect(current_path).to eq(users_path)
      end
    end

    context '既に登録済みの情報' do
      it 'ユーザー新規登録ができず、ユーザー登録画面に戻ってくる' do
        visit new_user_path
        expect(current_path).to eq(new_user_path)
        expect(page).to have_content('ユーザー登録')
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        fill_in 'パスワード確認', with: user.password_confirmation
        click_button '登録'
        expect(current_path).to eq(users_path)
      end
    end

    context 'パスワードが2文字以下' do
      it 'ユーザー新規登録ができず、ユーザー登録画面に戻ってくる' do
        visit new_user_path
        expect(current_path).to eq(new_user_path)
        expect(page).to have_content('ユーザー登録')
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'aa'
        fill_in 'パスワード確認', with: 'aa'
        click_button '登録'
        expect(current_path).to eq(users_path)
      end
    end

    context 'メールアドレスに@が含まれていない' do
      it 'ユーザー新規登録ができず、ユーザー登録画面に戻ってくる' do
        visit new_user_path
        expect(current_path).to eq(new_user_path)
        expect(page).to have_content('ユーザー登録')
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード確認', with: 'password'
        click_button '登録'
        expect(current_path).to eq(users_path)
      end
    end
  end
end
