angular.module 'ui.landingWidgets'



.directive 'lwExpandButton',
    () ->
        restrict: 'E'
        transclude: true
        scope:{
            ngDisabled: '=?'
        }
        controller: ($scope) ->

        templateUrl: '/@@__SOURCE_PATH__/lwExpandButton.html'




.directive 'lwExpandArea',
    () ->
        restrict: 'E'
        transclude: true
        scope:{
            title: '@?',
            showArea: '=?',
            btnClass: '@?',
            ngDisabled: '=?'
        }
        controller: ($scope) ->

        templateUrl: '/@@__SOURCE_PATH__/lwExpandArea.html'
