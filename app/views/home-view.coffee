template = require 'templates/home'
class HomeView extends Backbone.Layout
  template: template
  el: false
  afterRender: =>
    @mapContainer = $(".map").get(0)
    L.Icon.Default.imagePath = 'images'
    @renderMap()

  renderMap:  =>
    $(@mapContainer).empty()
    window.map = @map = L.map(@mapContainer)

    @tilelayers =
      google: new L.tileLayer("http://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}")
      local: new L.tileLayer("tiles/{z}/{x}/{y}.png")
    tiles = $ "ul.tumbler a"
    for tile in tiles
      $(tile).click _.partial(@toggleTileLayer, $(tile).data("layer"))

    @map.locate({setView: true, maxZoom: 18})
    @toggleTileLayer "google"
    #    $.get("data.geojson").success (data)=>
    #      L.geoJson(JSON.parse(data)).addTo @map

    @map.on 'locationfound', @onLocationFound

    @map.on 'locationerror', (e) -> alert(e.message)

    @editMode = location.search.split('editMode=')[1]
    @enableEditMode() if @editMode


  toggleTileLayer: (layerKey) =>
    for key, value of @tilelayers
      @map.removeLayer value
    tiles = $ "ul.tumbler a"
    tiles.removeClass "active"
    layer = @tilelayers[layerKey]
    $("ul.tumbler a[data-layer=#{layerKey}]").addClass "active"
    @map.addLayer layer
    no

  onLocationFound: (e)=>
    radius = e.accuracy / 2;
    L.marker(e.latlng).addTo(@map).bindPopup("Мы находимся гдето в радиусе " + radius + " метров от этого места").openPopup()
    L.circle(e.latlng, radius).addTo(@map)

  enableEditMode: =>
    window.rect = {}

    if typeof Number::toRad == 'undefined'
      Number::toRad = ->
        this * Math.PI / 180

    @map.on 'click', (e) =>
      obj = @getTileURL(e.latlng.lat, e.latlng.lng, map.getZoom())
      #      console.log("#{e.latlng.lat}, #{e.latlng.lng}")
      if !window.rect[obj.z]
        window.rect[obj.z] = []
      window.rect[obj.z].push [
        obj.x
        obj.y
      ]

  getTileURL: (lat, lon, zoom) ->
    xtile = parseInt(Math.floor((lon + 180) / 360 * (1 << zoom)))
    ytile = parseInt(Math.floor((1 - (Math.log(Math.tan(lat.toRad()) + 1 / Math.cos(lat.toRad())) / Math.PI)) / 2 * (1 << zoom)))
    {
      z: zoom
      x: xtile
      y: ytile
    }

module.exports = HomeView