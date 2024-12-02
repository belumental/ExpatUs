import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="join-button"
export default class extends Controller {
  join(event) {
    event.preventDefault()

    const chatId = this.element.dataset.chatId

    fetch(`/joined_chats`, {
            method: 'POST',
            headers: {
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({ chat_id: chatId })
          })
          .then(response => response.json())
          .then(data => {
            this.element.innerText = 'Joined!'
            this.element.disabled = true;
          })
  }
}
