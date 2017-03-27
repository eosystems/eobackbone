'use strict';

angular.module('eoApp')

.factory(
    'getCorpWalletDivision',
    function($q, $http) {
        return function(corporation_id) {
            var deferred = $q.defer();
            $http({
                    url: '/api/corp_wallet_divisions',
                    method: 'GET',
                    params: {corporation_id: corporation_id}
                })
                .success(function(res) {
                    deferred.resolve(res.results);
                });
            return deferred.promise;
        };
    }
);
