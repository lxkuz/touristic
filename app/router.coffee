HeaderView = require 'views/header-view'
HomeView = require 'views/home-view'
template = require 'templates/layout'
class Router extends Backbone.Router
  initialize: ->
    super
    @layout = new Backbone.Layout
      template: template
      el: false
      suppressWarnings: true
      views: 
        "header": new HeaderView()
    @layout.$el.appendTo("body");
    @layout.render()
  
  routes:
    '': 'home'

  home: ->
    @layout.setView("section", new HomeView()).render()

 

module.exports = Router