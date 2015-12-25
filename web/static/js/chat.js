import {Socket} from "deps/phoenix/web/static/js/phoenix"
import "deps/phoenix_html/web/static/js/phoenix_html"

class Chat {
  static init() {
    console.log("Initialized")
    var msgBody  = $("#message")
    var conversationId = $("meta[name=conversation_id]").attr("content")

    let socket = new Socket("/socket")
    socket.connect({user_token: $("meta[name=user_token]").attr("content")})
    socket.onClose( e => console.log("Closed connection") )

    var channel = socket.channel("conversations:"+conversationId, {})
    channel.join()
      .receive( "error", () => console.log("Connection error") )
      .receive( "ok",    () => console.log("Connected") )

    msgBody.off("keypress")
      .on("keypress", e => {
        if (e.keyCode == 13) {
          console.log(`${msgBody.val()}`)
          channel.push("new:message", {
            body: msgBody.val()
          })
          msgBody.val("")
        }
        else {
         channel.push("typing_indicator")
        }
      })
    channel.on("new:message", message => this.renderMessage(message))
    channel.on("typing_indicator", response => this.displayTypingIndicator(response.user))
  }

  static renderMessage(message) {
    let messages = $("#messages")
    let user = this.sanitize(message.user || "New User")
    let body = this.sanitize(message.body)

    messages.append(`<p><b>[${user}]</b>: ${body}</p>`)
  }

  static displayTypingIndicator(user) {
    if (user.id != $("meta[name=user_id]").attr("content")) {
      let messages = $("#messages")
      let sanitized_user = this.sanitize(user.email || "New User")

      $("#" + `user_${user.id}_typing_indicator`).remove()
      messages.append(`<p id='user_${user.id}_typing_indicator'>${sanitized_user} is typing...</p>`)
      $("#" + `user_${user.id}_typing_indicator`).show().delay(500).fadeOut();
    }
  }

  static sanitize(str) { return $("<div/>").text(str).html() }
}

$( () => Chat.init() )

export default Chat 
