import consumer from "channels/consumer"

consumer.subscriptions.create("PresenceChannel", {
  connected() {
    console.log("Connected to presence channel")
  },

  disconnected() {
    console.log("Disconnected from presence channel")
  },

  received(data) {
    // console.log(data.html)
    // const continer = document.getElementById("my-chats-online-users")
    // continer.innerHTML = data.html
    const chat_ids = Object.keys(data.chats_online_num)
    const online_nums = Object.values(data.chats_online_num)
    for(var i = 0, len = chat_ids.length; i < len; i++) {
      const tagid = `online-users-list-${chat_ids[i]}`
      const tag = document.getElementById(tagid)
      console.log(tagid)
      if (online_nums[i] == 0){
        tag.classList.remove("bg-success-transparent").add("bg-light text-dark")
      }
      tag.innerText = `${online_nums[i].length} Online`
    }
  }
})
