angular.module('app').controller('notificacionesController', function notificacionesController($scope, $http) {

  var ctrl = this;

  $scope.todasNotificaciones = [];

  $scope.config = {
    itemsPerPage: 10,
    fillLastPage: false
  }

  initController();

  function initController() {
    consultarTodasNotificaciones()
  }

  function consultarTodasNotificaciones() {
    $http.get('/notification')
      .then(function (response) {
        $scope.todasNotificaciones = response.data;
      });
  }



  $scope.filtrarxDias = function filtrarxDias(dias) {
    $http.get('/notification')
      .then(function (response) {
        notificaciones = response.data;
        $scope.todasNotificaciones = [];
        for(i = 0; i<notificaciones.length;i++){
          fechaSinUTC =  notificaciones[i].fecha.replace('Z', '');
          fechaNotificacion = new Date(fechaSinUTC);
          fechaInicial = sumarDias(new Date(),-dias);
          fechaNotificacion.setHours(0,0,0,0);
          fechaInicial.setHours(0,0,0,0);
          if (fechaNotificacion >= fechaInicial){
            $scope.todasNotificaciones.push(notificaciones[i]);
          }
        }
      });

  }

  function sumarDias(fecha, dias) {
    fecha.setDate(fecha.getDate() + dias);
    return fecha;
  }

  $scope.obtenerImagenCanal = function obtenerImagenCanal(canal) {
    if (canal == 1){
      return 'img/booking.png';
    }else if(canal == 2){
      return 'img/expedia.png';
    }
  }


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