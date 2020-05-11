require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#create' do
    context 'messageを保存できる場合' do  # contextで特定の条件でテストのグループ分けができる
      it 'is valid with content' do
        #be_validマッチャ→expectの引数にしたインスタンスが全てのバリデーションをクリアしたらパス
        #build()でFactoryBotで作成したインスタンスを呼んでくる
        expect(build(:message, image: nil)).to be_valid 
      end

      it 'is valid with image' do
        expect(build(:message, content: nil)).to be_valid
      end

      it 'is valid with content and image' do
        expect(build(:message)).to be_valid
      end
    end

    context 'messageが保存できない場合' do
      it 'is invalid without content and image' do
        message = build(:message, content: nil, image: nil)
        # valid?メソッドで保存できるかチェック＋errorsメソッドでエラー文を呼び出しエラーの原因を表示する
        message.valid?
        expect(message.errors[:content]).to include("を入力してください")
      end

      it 'is invalid without group_id' do
        message = build(:message, group_id: nil)
        message.valid?
        expect(message.errors[:group]).to include("を入力してください")
      end

      it 'is invaid without user_id' do
        message = build(:message, user_id: nil)
        message.valid?
        expect(message.errors[:user]).to include("を入力してください")
      end
    end
  end

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
    end

    context 'ログインしていない場合' do
      before do
        get :index, params: { group_id: group.id }
      end
    end

  end
end
