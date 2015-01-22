(function() {
	
	'use strict';
	
	angular.module('projectManagement')
		.service('AuthenticationSrvc', AuthenticationSrvc);
		
		function AuthenticationSrvc($q, TokenSrvc, CookieSrvc) {
			var AuthenticationSrvc = {};
			AuthenticationSrvc.signIn = signIn;
			
			function signIn(credentials) {
				var deferred = $q.defer();
				TokenSrvc.getToken(credentials)
					.then(
						function(response) {
							var token = response.data.token;
							var cookie = { key: 'token', value: token.string };
							CookieSrvc.set(cookie);
							deferred.resolve();
						},
						function(response) {
							deferred.resolve();
						}
					)
				return deferred.promise;				
			}
			
			return AuthenticationSrvc;
		}
		
		AuthenticationSrvc.$inject = ['$q', 'TokenSrvc', 'CookieSrvc'];
	
})();