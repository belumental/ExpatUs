import { Controller } from "@hotwired/stimulus"
// import { fade } from "controllers/fade_in_out"

// Connects to data-controller="message"
export default class extends Controller {
  static values = { userId: Number}
  static targets = ['stars', 'msgId', 'starimgs']
  connect() {
    const currentUserId = parseInt(document.body.dataset.currentUserId, 10);
    console.log(`xxxxxxxxx ${currentUserId}`)
    if (this.userIdValue === currentUserId) {
      this.element.classList.add('sent');
      this.element.classList.remove('received');
    } else {
      this.element.classList.add('received');
      this.element.classList.remove('sent');
    }
    this.element.scrollIntoView({ behavior: 'smooth' }); // scroll to the bottom of the page
  }

  star(event){
    const msgId = [event.target.previousElementSibling.previousElementSibling.value]
    const data = { messageIds: msgId };
    console.log(data)
    const url = "/stareds"
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
    fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken,
      },
      body: JSON.stringify(data),
    })
      .then((response) => response.json())
      .then((data) => {
        if(data.starred == true){
          event.target.parentElement.classList.remove('star')
          event.target.parentElement.classList.add('stared')
          event.target.classList.add('d-none')
          event.target.previousElementSibling.classList.remove('d-none')
        }else{
          alert("Star false!")
        }
      })
      .catch((error) => {
        console.error("Error:", error);
      });
  }

  unstar(event){
    const msgId = event.target.previousElementSibling.value
    console.log(msgId)
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
    fetch(`/stareds/${msgId}`, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken,
      },
    })
      .then((response) => response.json())
      .then((data) => {
        if(data.starred == true){
          event.target.parentElement.classList.remove('stared')
          event.target.parentElement.classList.add('star')
          event.target.classList.add('d-none')
          event.target.nextElementSibling.classList.remove('d-none')
        }else{
          alert("Unstar false!")
        }
      })
      .catch((error) => {
        console.error("Error:", error);
      });
  }
}
