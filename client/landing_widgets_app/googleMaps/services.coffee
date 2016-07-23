angular.module 'ui.landingWidgets'


.service '$lwGooglemap', ($rootScope) ->
    @loaded = false
    @_callbacks = []
    @_added_to_head = false


    window.lwGooglemapInitMap = ()=>
        $rootScope.$apply ()=>
            for c in @_callbacks
                c()
            @_callbacks = []
            @loaded = true

    head = document.getElementsByTagName('head')[0]
    insertBefore = head.insertBefore
    head.insertBefore = (newElement, referenceElement) ->
        # запрещаем наглому googlemaps загружать свои шрифты
        # по факту, правда, мы запрещаем зугрузку всех шрифтов из js на fonts.googleapis.com
        if newElement.href and newElement.href.indexOf('https://fonts.googleapis.com') == 0
            return
        insertBefore.call(head, newElement, referenceElement)


    @initMap = (cb)=>
        if not @_added_to_head and not @loaded
            @_callbacks.push(cb)
            script = document.createElement('script')
            script.src = "https://maps.googleapis.com/maps/api/js?key=AIzaSyDqPnzSiMCuFXwOe28LeNC4ZUSHzWxM31k&sensor=false&callback=window.lwGooglemapInitMap"
            script.type = "text/javascript"
            document.getElementsByTagName('head')[0].appendChild(script)
            @_added_to_head = true
            return
        if @loaded
            cb()
        else
            @_callbacks.push(cb)



    @
