(function() {
	
	'use strict';
	
	angular.module('projectManagement')
		.service('AuthenticationSrvc', AuthenticationSrvc);
		
		function AuthenticationSrvc(TokenSrvc) {
			var AuthenticationSrvc = {};
			AuthenticationSrvc.signIn = signIn;
			
			function signIn(credentials) {
				TokenSrvc.getToken(credentials)
					.then(
						function(response) {
							
						},
						function(response) {
							
						}
					)
			}
			
			return AuthenticationSrvc;
		}
		
		AuthenticationSrvc.$inject = ['TokenSrvc'];
	
})();