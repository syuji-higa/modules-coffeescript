_ = require 'lodash'

###
@dependsOn lodash
###
module.exports =
class GoogleMap

  ###
  @private
  @property [Object] default options
  ###
  defOpts =
    markerLatlngs: null
    mapOpts:
      zoom             : 15
      scrollwheel      : false
      mapTypeControl   : false
      streetViewControl: false
      draggable        : true
      backgroundColor  : '#e4e158'
      styles           : [{"featureType":"water","elementType":"geometry","stylers":[{"color":"#004358"}]},{"featureType":"landscape","elementType":"geometry","stylers":[{"color":"#1f8a70"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#1f8a70"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#fd7400"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#1f8a70"},{"lightness":-20}]},{"featureType":"road.local","elementType":"geometry","stylers":[{"color":"#1f8a70"},{"lightness":-17}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#ffffff"},{"visibility":"on"},{"weight":0.9}]},{"elementType":"labels.text.fill","stylers":[{"visibility":"on"},{"color":"#ffffff"}]},{"featureType":"poi","elementType":"labels","stylers":[{"visibility":"simplified"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#1f8a70"},{"lightness":-10}]},{},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#1f8a70"},{"weight":0.7}]}]
    markerOpts:
      animation: google.maps.Animation.DROP
      # icon:
      #   url        : ''
      #   scaledSize : new google.maps.Size 24, 41
    # infoWindowOpts:
    #   content: '<section>テキスト</section>'

  ###
  create GoogleMap instance
  @param el [String|HTMLElement] element
  @param letLen [Array] Latitude, longitude
  @param opts [Object] google map api options
  ###
  constructor: (@el, latlng, opts = {}) ->
    { markerLatlngs, @mapOpts, @markerOpts, @infoWindowOpts } = _.defaultsDeep opts, defOpts

    @latlng = new google.maps.LatLng latlng[0], latlng[1]

    unless markerLatlngs
      markerLatlngs = [ latlng ]

    @markerLatlngs = _.map markerLatlngs, (latlng) ->
      new google.maps.LatLng latlng[0], latlng[1]

    # @infoWindow = new google.maps.InfoWindow infoWindowOpts

    @create()

  create: ->
    canvas = document.getElementById @el
    @mapOpts.center = @latlng
    map = new google.maps.Map canvas, @mapOpts

    @markerOpts.map = map
    _.forEach @markerLatlngs, (latlng) =>
      new google.maps.Marker _.merge @markerOpts,
        position: latlng

    # @infoWindow.open map
