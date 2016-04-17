angular.module 'ui.landingWidgets'



.directive 'lwFeaturesBlock',
    () ->
        ###
            управление количеством колонок внутри виджета:

            lw-features-block.lg-5-col.md-4-col.sm-3-col.xs-1-col
        ###
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
                return tr('Features')



        templateUrl: '/@@__SOURCE_PATH__/lwFeaturesBlock.html'


.directive 'lwFeaturesObject',
    () ->
        restrict: 'E'
        transclude: true
        scope:{
            imgUrl: '@?',
            imgClass: '@?',
            ngDisabled: '=?'
        }
        controller: ($scope) ->

        templateUrl: '/@@__SOURCE_PATH__/lwFeaturesObject.html'
