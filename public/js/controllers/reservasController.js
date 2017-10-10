angular.module('app').controller('reservasController', function reservasController($scope,$http) {
  /*$scope.getTodasReservas = [
    {
      huesped: 'juan camilo cerquera lozada',
      descripcion: 'Reserva 4 personas - 3 dias',
      fechaIngreso: '12/10/2017',
      canal: 'booking'
    }, {
      huesped: 'Claudia Ximena Bonilla',
      descripcion: 'Reserva 4 personas - 3 dias',
      fechaIngreso: '15/10/2017',
      canal: 'expedia'
    }
  ];*/
  var self = this;
  $http.get('/reservation').then(function (response) {
    $scope.getTodasReservas = response.data;
  })
});

