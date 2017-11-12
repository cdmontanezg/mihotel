angular
    .module('app')
    .controller('AuthCtrl', function($scope, $auth) {
        $scope.$on('auth:login-error', function(ev, reason) {
            $scope.error = reason.errors[0];
        });
    });