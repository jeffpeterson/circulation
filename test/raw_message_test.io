describe(RawMessage,
  msgRaw  := ":arsinh!~testman@example.com PRIVMSG #channel :Hello world!"
  msg     := RawMessage clone withLine(msgRaw)

  assert(msg raw == msgRaw)
  assert(msg prefix == "arsinh!~testman@example.com")
  assert(msg userhost == "~testman@example.com")
  assert(msg server == "example.com")
  assert(msg user == "~testman")
  assert(msg nick == "arsinh")
  assert(msg command == "privmsg")
  assert(msg trailing == "Hello world!")
  assert(msg content == "Hello world!")
  assert(msg params == list("#channel"))
  assert(msg target == "#channel")
)
