template = require 'templates/home'
class HomeView extends Backbone.Layout
  template: template
  el: false
  serialize: ->
    message: 'Hello World'

  afterRender: =>

    L.Icon.Default.imagePath = 'images';

    @map = L.map($(".map").get(0)).setView([51.505, -0.09], 13)

    googleTileUrl = "http://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}"
    #    localTileUrl = 'tiles/{z}/{x}/{y}.png'

    L.tileLayer googleTileUrl,
      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    .addTo(@map)

    L.marker([51.5, -0.09]).addTo(@map).bindPopup('A pretty CSS3 popup.<br> Easily customizable.').openPopup()

module.exports = HomeView