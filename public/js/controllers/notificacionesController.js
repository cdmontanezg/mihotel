angular.module('app').controller('notificacionesController', function notificacionesController($scope, $http) {

  var ctrl = this;

  $scope.todasNotificaciones = {};

  $scope.config = {
    itemsPerPage: 2,
    maxPages: 3,
    fillLastPage: false
  }

  $http.get('/notification')
    .then(function (response) {
      $scope.todasNotificaciones = response.data;
    });


  // function setPage(page) {
  //   $http.get('/notification',
  //     {
  //       params: {page: page}
  //     })
  //     .then(function (response) {
  //       ctrl.getTodasNotificaciones = response.data;
  //     })
  // }

});