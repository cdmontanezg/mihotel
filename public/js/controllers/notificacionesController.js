angular.module('app').controller('notificacionesController', function notificacionesController($scope) {
  $scope.getTodasNotificaciones = [
    {
      fecha: '12/10/2017',
      hora: '22:30',
      reserva:{
        huesped: 'juan camilo cerquera lozada',
        descripcion: 'Reserva 4 personas - 3 dias',
        fechaIngreso: '12/10/2017',
        canal: 'booking'
      }
    }, {
      fecha: '15/10/2017',
      hora: '06:12',
      reserva:{
        huesped: 'claudia ximena bonilla',
        descripcion: 'Reserva 2 personas - 1 dias',
        fechaIngreso: '15/10/2017',
        canal: 'expedia'
      }
    }
  ];
});