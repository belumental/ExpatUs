document.addEventListener('DOMContentLoaded', function() {
  const joinButtons = document.querySelectorAll('.join-btn');

  joinButtons.forEach(function(button) {
    button.addEventListener('click', function(event) {
      event.preventDefault();

      const chatId = button.getAttribute('data-chat-id');
      fetch(`/chats/:id/join`, {
        method: 'POST',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: JSON.stringify({ chat_id: chatId })
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          button.textContent = 'Joined';
          button.disabled = true;
        } else {
          alert('There was an error joining the chat.');
        }
      })
      .catch(error => console.error('Error joining the chat:', error));
    });
  });
});
