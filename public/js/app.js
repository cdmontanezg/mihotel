// Default colors
var brandPrimary =  '#20a8d8';
var brandSuccess =  '#4dbd74';
var brandInfo =     '#63c2de';
var brandWarning =  '#f8cb00';
var brandDanger =   '#f86c6b';

var grayDark =      '#2a2c36';
var gray =          '#55595c';
var grayLight =     '#818a91';
var grayLighter =   '#d1d4d7';
var grayLightest =  '#f8f9fa';

var app = angular
.module('app', [
    'ui.router',
    'oc.lazyLoad',
    'ncy-angular-breadcrumb',
    'angular-loading-bar',
    'angular-table',
    'ngDialog',
    'ng-token-auth'
])
.config(['cfpLoadingBarProvider', '$authProvider', function(cfpLoadingBarProvider, $authProvider) {
    cfpLoadingBarProvider.includeSpinner = false;
    cfpLoadingBarProvider.latencyThreshold = 1;
    $authProvider.configure({
        apiUrl: '/api'
    });
}])
.run(['$rootScope', '$state', '$stateParams', function($rootScope, $state, $stateParams) {
  $rootScope.$on('$stateChangeSuccess',function(){
    document.body.scrollTop = document.documentElement.scrollTop = 0;
  });

    $rootScope.$on('auth:login-success', function() {
        $state.go('app.main');
    });
    $rootScope.$on('auth:invalid', function() {
        $state.go('appSimple.login');
    });
    $rootScope.$on('auth:validation-error', function() {
        $state.go('appSimple.login');
    });
    $rootScope.$on('auth:logout-success', function() {
        $state.go('appSimple.login');
    });
  $rootScope.$state = $state;
  return $rootScope.$stateParams = $stateParams;
}]);
