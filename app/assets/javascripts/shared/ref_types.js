'use strict';

angular.module('eoApp')

.factory(
    'getRefTypes',
    function($q, $http) {
        var deferred = $q.defer();

        $http({
                url: '/api/ref_types',
                method: 'GET'
            })
            .success(function(res) {
                deferred.resolve(res.results);
            });
        return deferred.promise;
    }
);
