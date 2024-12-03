import { Controller } from "@hotwired/stimulus"


function fadeOut(element) {
  if(element.style.opacity !=0){
    let speed = speed || 30 ;
    let num = 10;
    let st = setInterval(function(){
      num--;
      element.style.opacity = num / 10 ;
      if(num<=0)  { clearInterval(st); }
    },speed);
  }
}
// Connects to data-controller="message"
export default class extends Controller {
  static values = { userId: Number, msgId: Number }
  static targets = ['checkDivs', 'checks', 'checklabel', 'success']
  connect() {
    const currentUserId = parseInt(document.body.dataset.currentUserId, 10);
    if (this.userIdValue === currentUserId) {
      this.element.classList.add('sent');
      this.element.classList.remove('received');
    } else {
      this.element.classList.add('received');
      this.element.classList.remove('sent');
    }
    this.element.scrollIntoView({ behavior: 'smooth' }); // scroll to the bottom of the page
  }

  saveChecked(event) {
    if(event.target.checked == true){
      this.checkDivsTargets.forEach(function (element) {
        element.classList.remove('d-none')
      });
      this.checklabelTarget.innerText = "Confirm"
    }else{
      let checkedTags = []
      this.checksTargets.forEach((ele) => {
        if(ele.checked == true){
          checkedTags.push(ele)
        }
      })
      console.log(this.msgIdValue)
      if (checkedTags == 0){
        return
      }
      let messageIds = []
      checkedTags.forEach((checkedTag) => {
        messageIds.push(checkedTag.value)
      })
      const data = { messageIds: messageIds };
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
            const alertSuccess = this.successTarget
            alertSuccess.classList.remove("d-none")
            fadeOut(alertSuccess)
          }else{
            alert("false")
          }
        })
        .catch((error) => {
          console.error("Error:", error);
        });
      this.checkDivsTargets.forEach(function (element) {
        element.classList.add('d-none')
      });
      this.checklabelTarget.innerText = "Star Messages"
    }
  }

}
