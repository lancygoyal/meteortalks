Router.map ->
  @route 'home',
    path: '/'
    waitOn: -> [
      Meteor.subscribe('videos'),
      Meteor.subscribe('videoCount')
    ]
    data: ->
      videos: Video.where({}, {sort: {uploadedAt: -1}})
      videoCount: Counts.get('videos-count')

  @route 'dashboard',
    path: '/dashboard'
    onBeforeAction: ->
      unless Meteor.loggingIn()
        AccountsEntry.signInRequired(@)

  @route 'videos',
    path: '/search/:query'
    waitOn: -> [
      Meteor.subscribe('videos', @params.query),
    ]
    data: ->
      videos: Video.where({}, {sort: {uploadedAt: -1}})
      query: @params.query

  @route 'notFound',
    path: '*'
    where: 'server'
    action: ->
      @response.statusCode = 404
      @response.end Handlebars.templates['404']()
