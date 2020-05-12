require 'rails_helper'

describe MessagesController do

  describe '#index' do
    # メッセージ一覧でテストすべき点
      # ログインしている場合
        # アクション内で定義しているインスタンス変数があるか
        # 該当するビューが描画されているか
      # ログインしていない場合
        # 意図したビューにリダイレクトしているか

    # 複数のexample内で同一のインスタンスを使用したい場合、letメソッドを使う
    # letメソッドは初回の呼び出し時のみ実行される（遅延評価）。繰り返しがないので高速
    # 
    let(:group) { create(:group) }
    let(:user) { create(:user) }

    context 'ログインしている場合' do
      # beforeメソッドは、各exampleが実行される直前に、毎回実行される。ここに共通の処理をまとめておく
      before do
        # ここのloginメソッドはmacrosで定義したもの
        login user  
        # 擬似的にindexアクションを動かすリクエストを行うためにgetメソッドを使用
        # messagesはgroupsにネストしているので、group_idが必要。getメソッドの引数にparams以下を渡している
        get :index, params: { group_id: group.id }
      end


      it '@messageに期待した値が入っていること' do
        # assigns(:message)とする事で@messageの中身を確認できる
        # @messageはMessage.newで定義された新しいMessageクラスのインスタンス
        # be_a_newマッチャを使う事で()で指定したクラスのインスタンスかつ未保存のレコードであるかを確かめる
        expect(assigns(:message)).to be_a_new(Message)
      end

      it '@groupに期待した値が入っていること' do
        expect(assigns(:group)).to eq group
      end

      it 'index.html.erb に遷移すること' do
        # responseは、example内でリクエストが行われた後の遷移先のビューの情報を持つインスタンス
        # render_templateマッチャは引数にアクション名をとり、引数で指定されたアクションがリクエストされた時に自動的に遷移するビューを返す
        expect(response).to render_template :index
      end

    end

    context 'ログインしていない場合' do
      before do
        get :index, params: { group_id: group.id }
      end

      it 'ログイン画面にリダイレクトすること' do
        expect(response).to redirect_to(new_user_session_path)
      end
      
    end
  end

  describe '#create' do
    # ログインしているかつ、保存に成功した場合
      # メッセージの保存はできたのか
      # 意図したページに遷移できているか
    # ログインしているが、保存に失敗した場合
      # メッセージの保存は行われなかったか
      # 意図したビューに遷移しているか
    # ログインしていない場合
      # 意図した画面にリダイレクトしているか

    # ここのparamsは、擬似的にcreateアクションにリクエストする際に引数として渡すもの
    # attributes_forはbuild同様FactoryBotによって定義されるメソッド。オブジェクトを生成せずハッシュを生成する

    let {:params}{{group_id: group.id, user_id: user.id, message: attributes_for(:message)}}


    context 'ログインしている場合' do
      before do
        login user
      end
      
      # expectの記述が長くなる場合はsubjectで記述を切り出す
      subject {
        post :create,
        params: params
      }

      context '保存に成功した場合' do

        it 'messageを保存すること' do
        # changeマッチャは引数が変化したかどうか確かめる
        # Messageモデルのレコードが1個増えたかどうかを確かめる
        expect(subject).to change(Message, :conut).by(1)
        end

        it 'group_messages_pathへリダイレクトすること' do
          expect(response).to redirect_to(group_messages_path(group))
        end

      end

      context '保存に失敗した場合' do
      end

    end

    context 'ログインしていない場合' do
      before do
        get :create, params: params
    end

  end

end