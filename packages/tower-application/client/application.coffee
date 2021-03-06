###
global error handling

$(window).error (event) ->
  try
    App.errorHandler(event)
  catch error
    console.log(error)
###

class Tower.Application extends Tower.Engine
  @reopenClass
    _callbacks: {}

    instance: ->
      @_instance

  @before 'initialize', 'setDefaults'

  @reopen
    setDefaults: ->
      #Tower.Model.default "store", Tower.NetResponse
      #Tower.Model.field "id", type: "Id"

      true

    teardown: ->
      Tower.Route.reload()

    init: ->
      @_super arguments...

      throw new Error("Already initialized application") if Tower.Application._instance

      Tower.Application._instance = @

    ready: ->
      @_super arguments...

      #$("a").on 'click', ->
      #  Tower.get($(this).attr("href"))

    initialize: ->
      @extractAgent()
      @setDefaults()
      @_super(Tower.router)
      @

    extractAgent: ->
      Tower.cookies = Tower.NetCookies.parse()
      Tower.agent   = new Tower.NetAgent(JSON.parse(Tower.cookies["user-agent"] || '{}'))

    listen: ->
      return if @listening
      @listening = true

      Tower.url ||= "#{window.location.protocol}//#{window.location.host}"
      # Clients can only be connected to 1 connection in certain browser, this is a known hack I guess!
      # see https://groups.google.com/forum/#!msg/socket_io/eNSAXgE9FjA/wv5zN0OpKpkJ
      #Tower.socketUrl ||= "#{window.location.protocol}://io-#{Tower.port}.#{window.location.host}"
      Tower.socketUrl ||= Tower.url
      
      Tower.NetConnection.initialize()
      Tower.NetConnection.listen(Tower.socketUrl)

    run: ->
      @listen()
