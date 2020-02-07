$(function(){

  var reloadMessages = function() {
    //カスタムデータ属性を利用し、ブラウザに表示されている最新メッセージのidを取得
    last_message_id = $('.chat--content:last').data("message-id");
    console.log(last_message_id);
    $.ajax({
      //ルーティングで設定した通り/groups/id番号/api/messagesとなるよう文字列を書く
      url: "api/messages",
      //ルーティングで設定した通りhttpメソッドをgetに指定
      type: 'get',
      dataType: 'json',
      //dataオプションでリクエストに値を含める
      data: {id: last_message_id}
    })
    .done(function(messages) {
      if (messages.length !== 0) {
        var insertHTML = '';
        $.each(messages, function(i, message) {
          insertHTML += buildHTML(message)
        });
        $('.chat--contents').append(insertHTML);
        $('.chat--contents').animate({ scrollTop: $('.chat--contents')[0].scrollHeight});
      }
    })
    .fail(function() {
      console.log('error');
    });
  };


  function buildHTML(message){
    
    if(message.content && message.image){
      var html = `
      <div class="chat--content" data-message-id="${message.id}">
        <div class="chat--content--top">
          <div class="chat--content--top__user--name">
            ${message.user_name}
          </div>
          <div class="chat--content--top__date">
            ${message.created_at}
          </div>
        </div>
      <div class="chat--content__message">
        ${message.content}
      </div>
      <div class="chat--content__message">
      <img src=${message.image}>
        </div>
      </div>
      `
    }
    
    else if(message.image){
      var html = `
      <div class="chat--content" data-message-id="${message.id}">
        <div class="chat--content--top">
          <div class="chat--content--top__user--name">
            ${message.user_name}
          </div>
          <div class="chat--content--top__date">
            ${message.created_at}
          </div>
        </div>
      <div class="chat--content__message">
      <img src=${message.image}>
        </div>
      </div>
      `
    } else if(message.content) {
      var html = `
      <div class="chat--content" data-message-id="${message.id}">
        <div class="chat--content--top">
          <div class="chat--content--top__user--name">
            ${message.user_name}
          </div>
          <div class="chat--content--top__date">
            ${message.created_at}
          </div>
        </div>
      <div class="chat--content__message">
          ${message.content}
        </div>
      </div>
      `
    }
    return html;
  };
  


  $('#new_message').on('submit',function(e){
    e.preventDefault()
    var formData = new FormData(this);
    var url = $(this).attr('action')
    $.ajax({
      url: url,
      type: 'POST',
      data: formData,
      dataType: 'json',
      processData: false,
      contentType: false
    })
    .done(function(data){
      var html = buildHTML(data);
      $('.chat--contents').append(html);
      $('.chat--contents').animate({ scrollTop: $('.chat--contents')[0].scrollHeight});

      $('form')[0].reset();
    })
    .fail(function() {
      alert("メッセージ送信に失敗しました");
    })
    .always(() => {
      $(".form--btn").removeAttr("disabled");
      });
  });
  if (document.location.href.match(/\/groups\/\d+\/messages/)) {
  setInterval(reloadMessages, 7000);
  }
});