angular.module('app').controller('tableroController', function tableroController($scope, $http) {

  initController();

  function initController() {
    $scope.labelsOcupadas = ['Ocupadas', 'Libres'];
    $scope.dataOcupadas = [15, 5];

    $scope.labelsporLiberar = ['Por liberar', ''];
    $scope.dataporLiberar = [10, 10];

    $scope.labelsporOcupar = ['Por Ocupar', ''];
    $scope.dataporOcupar = [5, 15];
  }
});