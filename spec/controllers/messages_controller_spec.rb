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
        expect(assigns(:message)).to be_a_new(Message)
      end

      it '@groupに期待した値が入っていること' do
        expect(assigns(:group)).to eq group
      end
    end

    context 'ログインしていない場合' do
      before do
        get :index, params: { group_id: group.id }
      end
    end

end