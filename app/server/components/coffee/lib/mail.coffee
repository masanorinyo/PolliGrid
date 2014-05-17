nodemailer = require("nodemailer")
verificationTokenModel = require("../models/verificationToken")
Mail = ->
  smtpTransport = nodemailer.createTransport("SMTP",
    service: "Gmail"
    auth:
      user: "masanorinyo@gmail.com"
      pass: "$Osaka1226"
  )
  @fill = (info) ->
    @mailOptions =
      from: "Masanori <masanorinyo@gmail.com>"
      to: info.receiver
      subject: info.subject
      text: info.textContent
      html: info.htmlContent

    return

  @send = ->
    smtpTransport.sendMail @mailOptions, (error, response) ->
      if error
        console.log error
      else
        console.log "Message sent: " + response.message
      return

    return

  return

module.exports = (info) ->
  instance = new Mail()
  console.log info
  instance.fill info
  instance.send()
  instance