(function() {
	
	'use strict';
	
	angular.module('projectManagement')
		.service('UserSrvc', UserSrvc);
		
		function UserSrvc($http, API_BASE) {
			var UserSrvc = {};
			UserSrvc.checkEmailUniqueness = checkEmailUniqueness;
			
			function checkEmailUniqueness(email) {
				return $http.get(API_BASE + '/users/email?email=' + email);
			}
			
			return UserSrvc;
		}
		
		UserSrvc.$inject = ['$http', 'API_BASE'];
	
})();