class MessagesController < ApplicationController
  before_action :set_group

  def index
     @message = Message.new  #Messageモデルの新しいインスタンス
    @messages = @group.messages.includes(:user) #グループに所属する全てのメッセージ
  end

  def create
    @message = @group.messages.new(message_params) #@groupに新しいメッセージを追加
    if @message.save
      respond_to do |format|
      format.html { redirect_to group_messages_path, notice: "メッセージを送信しました" }
      format.json
    end
    else
      @messages = @group.messages.includes(:user) #@messagesをリセット
      flash.now[:alert] = 'メッセージを入力してください'
      render :index
    end
  end

  private


  def message_params
    params.require(:message).permit(:content, :image).merge(user_id: current_user.id)
  end

  def set_group
    @group = Group.find(params[:group_id]) #最初にどのグループかを覚えて使えるようにする
  end

end
