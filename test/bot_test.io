Socket := Object clone
Socket clone := Socket
Socket forward  := method(str, self)
Socket buffer  := ""
Socket streamWrite := method(str, buffer = str)

describe(Bot,
  bot := Bot clone setNick("aNick")
  bot on(ping, pong(msg content))

  bot clone handle("PING :test", Socket)
  Socket buffer println
  assert(Socket buffer == "PONG :test\r\n")

  assert(bot nick == "aNick")

  Bot clone store atPut("string", "aString")
  assert(Bot store at("string") == "aString")
  assert(bot store at("string") == "aString")

  Bot clone store atPut("list", list)
  assert(Bot clone store at("list") == list)
  Bot store at("list") append("item1")
  assert(Bot clone store at("list") at(0) == "item1")


  assert(Bot clone host == "localhost")
  Bot clone send("TEST")
  assert(Socket buffer == "TEST\r\n")
)

// describe(Bot say,
//   // Bot clone say(")
// )


