angular.module('app').controller('notificacionesController', function notificacionesController($scope, $http, ngDialog) {

  $scope.todasNotificaciones = [];
  $scope.reserva;

  $scope.config = {
    itemsPerPage: 10,
    fillLastPage: false
  }

  initController();

  function initController() {
    filtrarDias(15);
  }

  $scope.filtrarxDias = function filtrarxDias(dias) {
    filtrarDias(dias);
  }

  function filtrarDias(dias) {
    $http.get('/notification',{params: {hotel_id: 1}})
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

  $scope.abrirReserva = function abrirReserva(idReserva) {
    obtenerReserva(idReserva);
    ngDialog.open({
      template: 'notificaciones/popupReserva.template.html',
      className: 'ngdialog-theme-default',
      scope: $scope,
      width: '50%'
    });
  }

  function obtenerReserva(idReserva) {
    $http.get('/reservation/' + idReserva)
      .then(function (response) {
        $scope.reserva = response.data;
      });
  }



});