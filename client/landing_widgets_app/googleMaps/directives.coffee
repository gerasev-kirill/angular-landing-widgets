angular.module 'ui.landingWidgets'


.directive 'lwGooglemapMarker', ($lwGooglemap)->
    restrict: 'E'
    scope:{
        marker: '=?',
        title: '@?',
        options: '=?'
    }
    template: """
        <div class="gmap"></div>
        <div class="gmap-static" ng-if="!$lwGooglemap.loaded">
            <img ng-src="{{staticMapUrl}}"/>
        </div>
    """
    link: ($scope, element, attrs) ->
        latLng =undefined
        map = undefined
        marker = undefined
        infoWindow = undefined
        $scope.staticMapUrl = ''
        $scope.$lwGooglemap = $lwGooglemap

        loadStaticMap = (marker, title)->
            el_map = element.children()[0]
            height = el_map.clientHeight
            width = el_map.clientWidth
            _marker = {
                color: 'green',
                label: 'M'
            }
            if marker instanceof Array
                _marker.latLng = marker
            else
                _marker.latLng = [marker.lat, marker.lng]

            url = "https://maps.googleapis.com/maps/api/staticmap"
            $scope.staticMapUrl = url + \
                "?zoom=15&size=#{width}x#{height}&maptype=roadmap&" + \
                "markers=color:#{_marker.color}|label:#{_marker.label}|#{_marker.latLng[0]},#{_marker.latLng[1]}"


        # place a marker
        createInfoWindow = (marker, content)->
            # close window if not undefined
            if infoWindow != undefined
                infoWindow.close()
            infoWindowOptions = {content: content}
            infoWindow = new google.maps.InfoWindow(infoWindowOptions)
            infoWindow.open(map, marker)

        setMarker = (map, position, title) ->
            if marker
                marker.setMap(null)
            if not content
                content = title
            markerOptions = {
                position: position,
                map: map,
                title: title,
                icon: 'https://maps.google.com/mapfiles/ms/icons/green-dot.png'
            }

            marker = new google.maps.Marker(markerOptions)
            google.maps.event.addListener  marker, 'click', ()->
                createInfoWindow(marker, title)

            if $scope.options
                if $scope.options.showTitle == false
                    return
            createInfoWindow(marker, title)




        $scope.$watch 'marker', (marker, old)->
            if not $lwGooglemap.loaded then return
            if marker == old
                return
            if not marker
                return
            if marker instanceof Array
                latLng = new google.maps.LatLng(marker)
            else
                latLng = new google.maps.LatLng(marker.lat, marker.lng)
            setMarker(map, latLng, $scope.title)
            loadStaticMap(marker, $scope.title)

        $scope.$watch 'title', (title)->
            if not $lwGooglemap.loaded then return
            setMarker(map, latLng, title)
            loadStaticMap($scope.marker, title)



        loadStaticMap($scope.marker, $scope.title)
        $lwGooglemap.initMap ()->
            if $scope.marker instanceof Array
                latLng = new google.maps.LatLng($scope.marker[0], $scope.marker[1])
            else
                latLng = new google.maps.LatLng($scope.marker.lat, $scope.marker.lng)
            # map config
            mapOptions = {
                center: latLng
                zoom: 15
                zoomControl: true
                mapTypeId: google.maps.MapTypeId.ROADMAP
                scrollwheel: false
            }
            if map == undefined
                console.log mapOptions
                map = new google.maps.Map(element.children()[0], mapOptions)

            setMarker(map, latLng, $scope.title)
            loadStaticMap($scope.marker, $scope.title)
