(function() {
	
	'use strict';
	
	angular.module('projectManagement')
		.service('TokenSrvc', TokenSrvc);
		
		function TokenSrvc($http, API_BASE) {
			var TokenSrvc = {};
			
			TokenSrvc.getToken = getToken;
			
			function getToken(credentials) {
				return $http.post(API_BASE + '/tokens', credentials);
			}
			
			return TokenSrvc;
		}
		
		TokenSrvc.$inject = ['$http', 'API_BASE'];
	
})();