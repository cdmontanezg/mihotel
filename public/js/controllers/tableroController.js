angular.module('app').controller('tableroController', function tableroController($scope, $http, $filter) {

  initController();

  function initController() {

    obtenerCuartosHotel();
    obtenerReservasHotel();
  }

  function obtenerCuartosHotel() {
    $http.get('/room',{params: {hotel_id: 1}})
      .then(function (response) {
        cuartos = response.data;
        ocupados = 0;
        libres = 0;
        for(i = 0; i<cuartos.length;i++){
         if(cuartos[i].status == 'Ready'){
           libres++;
         }else {
           ocupados++;
         }
        }
        $scope.labelsOcupadas = ['Ocupadas', 'Libres'];
        $scope.dataOcupadas = [ocupados, libres];
      });
  }

  function obtenerReservasHotel() {
    $http.get('/reservation',{params: {hotel_id: 1}})
      .then(function (response) {
        reservas = response.data;
        arregloDias = [];
        dias = 7;
        for(i = dias-1; i>=0;i--){
          fechaInicial = sumarDias(new Date(), -i) ;
          //fechaInicial.setHours(0,0,0,0);
          fechaInicial = $filter('date')(fechaInicial, 'dd/MM/yyyy');
          arregloDias.push(fechaInicial);
        }
        arregloReservasBooking = [0,0,0,0,0,0,0];
        arregloReservasExpedia = [0,0,0,0,0,0,0];
        dias = 7;
        fechaInicial = sumarDias(new Date(),-(dias-1));
        fechaInicial.setHours(0,0,0,0);
        for(i = 0; i<reservas.length;i++){
          fechaSinUTC =  reservas[i].date_from.replace('Z', '');
          fechaReserva = new Date(fechaSinUTC);
          fechaReserva.setHours(0,0,0,0);
          if (fechaReserva >= fechaInicial){
            //calcular diferencia en fechas
            dif = Math.floor((new Date().getTime() - fechaReserva.getTime())/(1000*60*60*24));
            if (reservas[i].channel_id == 1) {
              arregloReservasBooking[6-dif] = arregloReservasBooking[6-dif] + 1;
            } else if (reservas[i].channel_id == 2) {
              arregloReservasExpedia[6-dif] = arregloReservasExpedia[6-dif] + 1;
            }
          }
        }
        $scope.labels = arregloDias;
        $scope.series = ['Booking', 'Expedia'];
        $scope.dataCanales = [
          arregloReservasBooking,
          arregloReservasExpedia
        ];
      });
  }

  function sumarDias(fecha, dias) {
    fecha.setDate(fecha.getDate() + dias);
    return fecha;
  }
});