
angular.module 'ui.landingWidgets'




.directive 'lwAboutMonitorSlider',
    () ->
        ###
            @param {Array} slides = [{
                image: 'full/path/to.img',
                title: 'Sometitle',
                text: someText
            }]
            @param {number} interval - in msec
        ###
        restrict: 'E'
        scope:{
            slides: '=',
            interval: '=?',
            hideIndicators: '=?',
            hideControls: '=?',
            ngDisabled: '=?'
        }
        controller: ($scope) ->
            $scope.getInterval = () ->
                if $scope.interval
                    return $scope.interval
                return 3000


        templateUrl: '/@@__SOURCE_PATH__/lwAboutMonitorSlider.html'
