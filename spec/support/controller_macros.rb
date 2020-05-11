module ControllerMacros
  # 複数のユーザーでテストしたい場合、毎回ログインし直す処理を書くのは冗長。マクロ（ヘルパーメソッド）を用意しておくと便利。
  def login(user)
    @request.env["devise.mapping"] = Devise.mappings[user]
    sign_in user
  end

end