Tower.View.reopen
  # findEmberView('loginView')
  # findEmberView('posts/index') => 'postsIndexView'
  findEmberView: (path) ->
    # Ember.TEMPLATES[templateName] = Ember.Handlebars.compile(template)

    #viewName = _.camelize(path) + "View"
    #app = Tower.Application.instance()

    #if view = app.get(viewName)
    #  view
    #else if viewClass = app.get(_.camelize(viewName))
    #  view = viewClass.create()
    #  app.set(viewName, view)
    #else
    return null unless Ember.TEMPLATES.hasOwnProperty(path)
    view = Ember.View.create(templateName: path)
    #app.set(viewName, view)

    view
    
  renderEmberView: (options) ->
    outletOptions =
      outletName: options.outlet || 'view' # default value in ember
      viewClass:  @findEmberView(options)
      context:    options.data || @#get('content')

    @parentController().connectOutlet(outletOptions)
