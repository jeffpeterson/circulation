describe(Callback,
  before(
    callback := Callback clone do(
      setBody(block(return true) message)
      addFilter("""^(irc\.example\.net)""")
      addFilter("""^(irc)\.example\.net""")
      addFilter("""^(?<test>ir)c$""")
    )
    msg := RawMessage clone withLine("PING :irc.example.net")
  )

  assert( callback handle(msg, Object clone))
  assert(
    callback setBody(block(return test) message)
    callback handle(msg, Object clone) == "ir"
  )
)
