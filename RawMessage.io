RawMessage := Object clone do(
  params   := lazySlot(list)
  raw      := nil
  prefix   := nil
  command  := nil
  trailing := nil
  nick     := lazySlot(prefix split("!") at(0))
  userhost := lazySlot(prefix split("!") at(1))
  user     := lazySlot(userhost split("@") at(0))
  server   := lazySlot(userhost split("@") at(1))
  target   := lazySlot(params first)
  content  := lazySlot(if(trailing, trailing, params last))

  withLine := method(line,
    raw = line
    words := line split(" ")

    if(words first beginsWithSeq(":"), prefix = words removeFirst removePrefix(":"))

    command  = words removeFirst asLowercase

    while(word := words removeFirst,
      if(word beginsWithSeq(":")) then(
        words prepend(word removePrefix(":"))
        trailing = words join(" ")
        words = list
      ) else(
        params append(word)
      )
    )
    self
  )
)
