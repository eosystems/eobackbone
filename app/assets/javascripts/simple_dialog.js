angular.module('eoApp')

.controller(
    'SimpleDialogController',
    ['$scope', '$uibModalInstance',　'params', function($scope, $uibModalInstance, params){
        $scope.title = params.title;
        $scope.message = params.message;
        $scope.pressCancel = function(){
            $uibModalInstance.close('done');
        };
        $scope.pressSubmit = function(){
            $uibModalInstance.dismiss('done');
        };
    }]
);
