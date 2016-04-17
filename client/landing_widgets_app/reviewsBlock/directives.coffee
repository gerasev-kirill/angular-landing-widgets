angular.module 'ui.landingWidgets'



.directive 'lwReviewsBlock',
    () ->
        restrict: 'E'
        transclude: true
        scope:{
            title: '@?',
            headline: '@?',
            showTopControls: '=?',
            ngDisabled: '=?'
        }
        controller: ($scope, $element, $filter) ->
            $scope.currentPage = 0

            $scope.next = () ->
                objs = $element.find('page')
                $scope.currentPage += 1
                if $scope.currentPage >= objs.length
                    $scope.currentPage = 0

            $scope.prev = () ->
                $scope.currentPage -=1
                if $scope.currentPage < 0
                    objs = $element.find('page')
                    $scope.currentPage = objs.length - 1


            $scope.isNextPrevBtnsVisible = () ->
                $element.find('page').length

            try
              tr = $filter('translate')
            catch error
              tr = (text)-> text

            $scope.getTitle = () ->
                if $scope.title
                    return $scope.title
                return tr('Comments')

        templateUrl: '/@@__SOURCE_PATH__/lwReviewsBlock.html'




.directive 'lwReviewsObject',
    () ->
        restrict: 'E'
        transclude: true
        scope:{
            imgUrl: '@?',
            title: '@',
            ngHref: '@?',
            headline: '@?',
            ngDisabled: '=?'
        }
        controller: ($scope) ->

        templateUrl: '/@@__SOURCE_PATH__/lwReviewsObject.html'
