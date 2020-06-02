class Api::V1::SessionsController < Devise::SessionsController

  before_action :sign_in_params, only: :create
  before_action :load_user, only: :create
  before_action :valid_token, only: :destroy
  skip_before_action :verify_signed_out_user, only: :destroy

  #sign_in
  def create
    if @user.valid_password?(sign_in_params[:password])
      sign_in "user", @user
      json_response "Signed in successfully", true, {user: @user}, :ok
    else
      json_response "failed sign in", false, {}, :unauthorized
    end
  end

  #log out
  def destroy
    sign_out @user
    @user.generate_new_authentication_token
    json_response "Log out successfully", true, {}, :ok


  end


  def sign_in_params
    params.require(:user).permit(:email, :password)

    # この関数は以下のような値を返す
    #  {
    #      email: "naoya"
    #      password: "##########"
    #  }

  end


  def load_user
    #emailでuserを引っ張り出してくる
    @user = User.find_for_database_authentication(email: sign_in_params[:email])
    if @user
      return @user
    else
      json_response "Cannot get user", false, {}, :internal_server_error
    end
  end

  def valid_token
    @user = User.find_by authentication_token: request.headers["AUTH-TOKEN"]
    if @user
      return @user
    else
      json_response "Invalid token", false, {}, :internal_server_error
    end
  end

end

#サインイン
#ユーザーがフォームから入力してきたメールアドレス、パスワードをストロングパラメーターで受け取る。
# そのメールアドレスを頼りにデータベースからそのメールアドレスで登録しているユーザーを識別し、取得する。
# 取得したユーザーのパスワードと、フォームから送られてきたパスワードが一致するかを判定。
# 一致していればサインインする。

#ログアウト
#リクエストヘッダーからユーザーの認証トークンを取得し、新たな認証トークンを発行し、
#更新してあげることで現在の認証トークンを無効にしてログアウトさせる。
