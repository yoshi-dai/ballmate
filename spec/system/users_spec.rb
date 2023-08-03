require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end
  context 'ユーザー新規登録ができるとき' do
    it '正しく情報を入力すればユーザー新規登録ができ、ユーザープロフィール登録画面に移動する' do
      # ユーザー新規登録ページへ移動する
      visit new_user_path
      # 新規登録ページへ遷移する
      expect(current_path).to eq(new_user_path)
      expect(page).to have_content('ユーザー登録')
      # ユーザー情報を入力する
      fill_in 'メールアドレス', with: @user.email
      fill_in 'パスワード', with: @user.password
      fill_in 'パスワード確認', with: @user.password_confirmation
      # 登録ボタンを押す
      click_button '登録'
      # ユーザープロフィール登録ページへリダイレクトする
      expect(current_path).to eq(new_user_profile_path)
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができず、ユーザー登録画面に戻ってくる' do
      # ユーザー新規登録ページへ移動する
      visit new_user_path
      # 新規登録ページへ遷移する
      expect(current_path).to eq(new_user_path)
      expect(page).to have_content('ユーザー登録')
      # ユーザー情報を入力する
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: ''
      fill_in 'パスワード確認', with: ''
      # 登録ボタンを押す
      click_button '登録'
      # ユーザー登録ページへリダイレクトする
      expect(current_path).to eq(users_path)
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it 'すでに登録されているメールアドレスではユーザー新規登録ができず、ユーザー登録画面に戻ってくる' do
      # ユーザー新規登録ページへ移動する
      visit new_user_path
      # 新規登録ページへ遷移する
      expect(current_path).to eq(new_user_path)
      expect(page).to have_content('ユーザー登録')
      # ユーザー情報を入力する
      fill_in 'メールアドレス', with: '@user.email'
      fill_in 'パスワード', with: '@user.password'
      fill_in 'パスワード確認', with: '@user.password_confirmation'
      # 登録ボタンを押す
      click_button '登録'
      # ユーザー登録ページへリダイレクトする
      expect(current_path).to eq(new_user_path)
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it 'パスワードが2文字以下ではユーザー新規登録ができず、ユーザー登録画面に戻ってくる' do
      # ユーザー新規登録ページへ移動する
      visit new_user_path
      # 新規登録ページへ遷移する
      expect(current_path).to eq(new_user_path)
      expect(page).to have_content('ユーザー登録')
      # ユーザー情報を入力する
      fill_in 'メールアドレス', with: '@user.email'
      fill_in 'パスワード', with: 'aa'
      fill_in 'パスワード確認', with: 'aa'
      # 登録ボタンを押す
      click_button '登録'
      # ユーザー登録ページへリダイレクトする
      expect(current_path).to eq(new_user_path)
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it 'メールアドレスに@が含まれていないとユーザー新規登録ができず、ユーザー登録画面に戻ってくる' do
      # ユーザー新規登録ページへ移動する
      visit new_user_path
      # 新規登録ページへ遷移する
      expect(current_path).to eq(new_user_path)
      expect(page).to have_content('ユーザー登録')
      # ユーザー情報を入力する
      fill_in 'メールアドレス', with: 'user.email'
      fill_in 'パスワード', with: 'password'
      fill_in 'パスワード確認', with: 'password'
      # 登録ボタンを押す
      click_button '登録'
      # ユーザー登録ページへリダイレクトする
      expect(current_path).to eq(new_user_path)
    end
  end

  describe 'ユーザーログイン', type: :system do
    before do
      @user = FactoryBot.create(:user)
    end
    context 'ログインができるとき' do
      it '正しい情報を入力すればログインができ、トップページに移動する' do
        # ログインページへ移動する
        visit login_path
        # ログインページへ遷移する
        expect(current_path).to eq(login_path)
        expect(page).to have_content('ログイン')
        # ログイン情報を入力する
        fill_in 'メールアドレス', with: @user.email
        fill_in 'パスワード', with: 'password'
        # ログインボタンを押す
        click_button 'ログイン'
        # ログインに成功し、トップページにリダイレクトされることを確認する
        expect(current_path).to eq(root_path)
      end
    end
    context 'ログインができないとき' do
      it '誤った情報ではログインができず、ログイン画面に戻ってくる' do
        # ログインページへ移動する
        visit login_path
        # ログインページへ遷移する
        expect(current_path).to eq(login_path)
        expect(page).to have_content('ログイン')
        # ログイン情報を入力する
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        # ログインボタンを押す
        click_button 'ログイン'
        # ログインページへリダイレクトする
        expect(current_path).to eq(login_path)
      end
    end
  end
end
