$(function(){
  function buildHTML(message){
    if(message.image){
      var html = `
    <div class="chat--content">
      <div class="chat--content__user--name">
        ${message.user_name}
      </div>
      <div class="chat--content__date">
        ${message.created_at}
      </div>
    </div>
    <div class="chat--content__message">
      <img src=${message.image}>
    </div>
    `

    } else {
      var html = `
      <div class="chat--content">
        <div class="chat--content__user--name">
          ${message.user_name}
        </div>
        <div class="chat--content__date">
          ${message.created_at}
        </div>
      </div>
      <div class="chat--content__message">
        <p class="message__content">
          <p class="message__content"></p>
        </p>
          ${message.content}
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
      $('form')[0].reset();
      $('.chat--contents').animate({ scrollTop: $('.chat--contents')[0].scrollHeight});
    })
    .fail(function() {
      alert("メッセージ送信に失敗しました");
    })
    .always(() => {
      $(".form--btn").removeAttr("disabled");
      });
  });

});