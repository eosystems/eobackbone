'use strict';

angular.module('eoApp')

.factory(
    'getCorporation',
    function($q, $http) {
        var deferred = $q.defer();

        $http({
                url: '/api/my_corporations',
                method: 'GET'
            })
            .success(function(res) {
                deferred.resolve(res.results);
            });
        return deferred.promise;
    }
);
