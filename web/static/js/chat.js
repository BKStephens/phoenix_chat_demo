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
      })
    channel.on( "new:message", message => this.renderMessage(message) )
  }

  static renderMessage(message) {
    var messages = $("#messages")
    var user = this.sanitize(message.user || "New User")
    var body = this.sanitize(message.body)

    messages.append(`<p><b>[${user}]</b>: ${body}</p>`)
  }

  static sanitize(str) { return $("<div/>").text(str).html() }
}

$( () => Chat.init() )

export default Chat 
