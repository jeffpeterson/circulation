IoBot := Bot clone do(
  setHost("localhost")
  setPort(6666)
  setNick("ioBot")

  channel("#test")

  mention_match("^(?<thebody>.+)$" asRegex caseless, reply("I heard \"#{thebody}\"." interpolate))
  match(".ACTION (?<goingons>.*).", action("hears #{msg nick} #{goingons}" interpolate))

  start
)
