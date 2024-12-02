import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="starred"
export default class extends Controller {
  click(event) {
    event.preventDefault()

    const messageId = this.element.dataset.messageId

    console.log(messageId)
    fetch(`/stared`, {
            method: 'POST',
            headers: {
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({ message_id: messageId })
          })
          .then(response => response.json())
          .then(data => {
            this.element.innerHTML = data.starred
          ? '<i class="fa-solid fa-heart text-danger"></i>'
          : '<i class="fa-regular fa-heart"></i>';
          })
  }
}
