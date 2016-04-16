angular.module 'ui.landingWidgets'



.directive 'lwPricingBlock',
    () ->
        restrict: 'E'
        transclude: true
        scope:{
            title: '@?',
            headline: '@?',
            ngDisabled: '=?'
        }
        controller: ($scope, $filter) ->
            try
              tr = $filter('translate')
            catch error
              tr = (text)-> text

            $scope.getTitle = () ->
                if $scope.title
                    return $scope.title
                return tr('Pricing table')

        templateUrl: '/@@__SOURCE_PATH__/lwPricingBlock.html'



.directive 'lwPricingObject',
    () ->
        restrict: 'E'
        transclude: true
        scope:{
            priceStr: '@?',
            price: '=?',
            title: '@',
            headline: '@?',
            ngDisabled: '=?'
        }
        controller: ($scope) ->

        templateUrl: '/@@__SOURCE_PATH__/lwPricingObject.html'
