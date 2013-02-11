Regex

Callback := Object clone do(
  filters  ::= lazySlot(list)
  body     ::= nil
  addFilter := method(string, filters append(string); self)
  match     := true

  handle    := method(msg, context,
    filters = if(filters isKindOf(List), filters , list(filters))

    // Each filter is applied to the last capture of the previous filter
    filters select(f, f) ?reduce(str, filter,
      self match = str ?findRegex(filter)
      match ?captures last
    , msg content)

    if(match) then(
      match ?names foreach(name, context setSlot(name, match at(name)))
      context  doMessage(body)
    )
  )
)

Bot := Object clone do(
  host  ::= "localhost"
  port  ::= 6667
  nick  ::= "nick"
  channels ::= lazySlot(list)
  msg   ::= nil
  isPm   := lazySlot(msg target == nick)
  source := lazySlot(if(isPm, msg nick, msg target))
  addChannel := method(chan, channels append(chan))
  channel    := method(call delegateToMethod(self, "addChannel"))

  connection ::= lazySlot(Socket clone setHost(host) setPort(port) setReadTimeout(3600) connect)
  callbacks  := Map clone
  store      := Map clone

  addCallback := method(command, filters, body,
    callbacks atIfAbsentPut(command, list) append(
      Callback clone setBody(body) setFilters(filters)
    )
  )

  handle := method(line, sourceConnection,
    self msg    = RawMessage clone withLine(line)

    callbacks at(msg command, list) foreach(clone @@handle(msg, self clone setConnection(sourceConnection)))
  )

  pong   := method(content, send("PONG :#{content}" interpolate))
  send   := method(content, connection streamWrite(content .. "\r\n"))
  say    := method(content, privmsg(source, content))
  reply  := method(content, privmsg(source, if(isPm, content, "#{msg nick}: #{content}" interpolate)))
  action := method(content, privmsg(source, "#{1 asCharacter}ACTION #{content}#{1 asCharacter}" interpolate))

  privmsg := method(target, content,
    if(content containsSeq(" "), content = ":" .. content)
    content println
    send("PRIVMSG #{target} #{content}" interpolate)
  )

  start := method(
    send("NICK #{nick}" interpolate)
    send("USER #{nick} localhost #{host} :#{nick}" interpolate)
    send("JOIN " .. channels join(","))

    on(ping, pong(msg content))

    loop(
      clone handle(connection readUntilSeq("\r\n"), connection)
    )
  )

  mention_match := method(regexString,
    filters := list("""^(?|#{nick}[:\., ]*(.*)|(.*)[ ,]*#{nick})[\.! ?]*$""" interpolate asRegex caseless, regexString)
    addCallback("privmsg", filters, message(if(isPm, nil)) clone appendArg(call message arguments last))
    addCallback("privmsg", regexString, message(if(isPm != true, nil)) clone appendArg(call message arguments last))
  )

  match := method(regex,
    filters := list("""^(?:#{nick}[:\., ]*)?(.*)(?:[ ,]*#{nick}[\.! ?]*)?$""" interpolate asRegex caseless, regex)
    addCallback("privmsg", filters, call message arguments last)
  )

  on := method(
    command := call message argAt(0) name asLowercase
    body    := call message arguments last
    filters := if(call argCount == 3, call evalArgAt(1), nil)
    addCallback(command, filters, body)
  )
)
