'use strict';

angular.module('eoApp')

.factory(
    'getCorpWalletDivision',
    function($q, $http) {
        var deferred = $q.defer();

        $http({
                url: '/api/corp_wallet_divisions',
                method: 'GET'
            })
            .success(function(res) {
                deferred.resolve(res.results);
            });
        return deferred.promise;
    }
);
