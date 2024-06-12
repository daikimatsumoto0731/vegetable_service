$(document).ready(function() {
  // カレンダーの設定
  var calendarEl = document.getElementById('calendar');
  var calendar;

  if (calendarEl) {
    var vegetableId = $('#calendar').data('selected-vegetable-id');

    calendar = new FullCalendar.Calendar(calendarEl, {
      initialView: 'dayGridMonth',
      events: function(fetchInfo, successCallback, failureCallback) {
        $.ajax({
          url: '/events',
          type: 'GET',
          data: {
            vegetable_id: vegetableId
          },
          success: function(data) {
            console.log('Events loaded:', data); // デバッグ用ログ
            successCallback(data.map(function(event) {
              return {
                id: event.id,
                title: event.title,
                start: event.start_date,
                end: event.end_date,
                allDay: true,
                backgroundColor: event.color,
                borderColor: event.color
              };
            }));
          },
          error: function(jqXHR, textStatus, errorThrown) {
            console.log('Error loading events:', textStatus, errorThrown); // デバッグ用ログ
            failureCallback(errorThrown);
          }
        });
      },
      editable: true,
      eventDrop: function(info) {
        updateEvent(info.event);
      },
      eventContent: function(arg) {
        var deleteButton = document.createElement('button');
        deleteButton.innerHTML = '削除';
        deleteButton.classList.add('delete-button');
        deleteButton.addEventListener('click', function() {
          if (confirm('このイベントを削除しますか？')) {
            deleteEvent(arg.event);
          }
        });

        var title = document.createElement('div');
        title.innerHTML = arg.event.title;

        var container = document.createElement('div');
        container.classList.add('event-container');
        container.appendChild(title);
        container.appendChild(deleteButton);

        return { domNodes: [container] };
      }
    });

    calendar.render();
  }

  $('.stamp-button').on('click', function() {
    var stamp = $(this).data('stamp');
    var color = $(this).css('background-color'); // ボタンの背景色を取得
    var today = new Date().toISOString().split('T')[0];
    var vegetableId = $('#calendar').data('selected-vegetable-id');

    addStampToCalendar(stamp, today, vegetableId, color);
  });

  function addStampToCalendar(stamp, date, vegetableId, color) {
    console.log('Sending stamp:', stamp, 'on date:', date, 'for vegetable:', vegetableId, 'with color:', color); // デバッグ用ログ

    $.ajax({
      url: '/events',
      type: 'POST',
      contentType: 'application/json',
      dataType: 'json',
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
      },
      data: JSON.stringify({
        event: {
          title: stamp,
          start_date: date,
          end_date: date,
          vegetable_id: vegetableId,
          color: color // 色を送信
        }
      }),
      success: function(data) {
        console.log('Stamp added successfully:', data); // デバッグ用ログ
        calendar.addEvent({
          id: data.id,
          title: stamp,
          start: date,
          allDay: true,
          backgroundColor: color, // 背景色を設定
          borderColor: color // 枠色を設定
        });
        alert('スタンプが追加されました');
      },
      error: function(jqXHR, textStatus, errorThrown) {
        console.log('Error adding stamp:', textStatus, errorThrown); // デバッグ用ログ
        alert('スタンプの追加に失敗しました: ' + textStatus);
      }
    });
  }

  function updateEvent(event) {
    $.ajax({
      url: '/events/' + event.id,
      type: 'PATCH',
      contentType: 'application/json',
      dataType: 'json',
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
      },
      data: JSON.stringify({
        event: {
          start_date: event.start.toISOString().split('T')[0],
          end_date: event.end ? event.end.toISOString().split('T')[0] : event.start.toISOString().split('T')[0]
        }
      }),
      success: function(data) {
        console.log('Event updated successfully:', data);
      },
      error: function(jqXHR, textStatus, errorThrown) {
        console.log('Error updating event:', textStatus, errorThrown);
        alert('イベントの更新に失敗しました: ' + textStatus);
      }
    });
  }

  function deleteEvent(event) {
    $.ajax({
      url: '/events/' + event.id,
      type: 'DELETE',
      contentType: 'application/json',
      dataType: 'json',
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
      },
      success: function() {
        console.log('Event deleted successfully');
        event.remove();
      },
      error: function(jqXHR, textStatus, errorThrown) {
        console.log('Error deleting event:', textStatus, errorThrown); // デバッグ用ログ
        alert('イベントの削除に失敗しました: ' + textStatus);
      }
    });
  }

  // モーダルを表示するボタンがクリックされたときの処理
  $('[data-toggle="modal"]').on('click', function() {
    var targetModal = $(this).data('target');
    $(targetModal).modal('show');
  });

  // 画像を分析するモーダル表示用のボタンがクリックされたときの処理
  $('#analyzeImageModal').on('show.bs.modal', function(event) {
    var button = $(event.relatedTarget); // 適切なボタンを取得
    var modal = $(this);
    modal.find('.modal-body input').val('');
  });

  $('#analyze_image_form').on('submit', function(e) {
    e.preventDefault(); // フォームのデフォルト送信を防ぐ
    var formData = new FormData(this);
    $.ajax({
      url: $(this).attr('action'),
      type: 'POST',
      data: formData,
      contentType: false,
      processData: false,
      success: function(data) {
        $('#analyzeImageModal .modal-body').html(data);
        $('#analyzeImageModal').modal('show');
      },
      error: function(jqXHR, textStatus, errorThrown) {
        alert('画像の分析に失敗しました: ' + textStatus);
      }
    });
  });
});
