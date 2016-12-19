angular.module('eoApp')

.controller(
    'DetailDialogController',
    ['$scope', '$uibModalInstance',　'params', function($scope, $uibModalInstance, params){
        $scope.title = params.title;
        $scope.message1 = params.message1;
        $scope.message2 = params.message2;
        $scope.message3 = params.message3;
        $scope.pressSubmit = function(){
            $uibModalInstance.close('done');
        };
    }]
);
