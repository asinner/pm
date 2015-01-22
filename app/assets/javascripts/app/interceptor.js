(function() {
	
	'use strict';
	
	angular.module('projectManagement')
		.factory('Interceptor', Interceptor)
		.config(['$httpProvider', function($httpProvider) {
			$httpProvider.interceptors.push('Interceptor');
		}]);
		
		function Interceptor(CookieSrvc) {
			var Interceptor = {};
			
			Interceptor.request = request;
						
			function request(config) {
				if (CookieSrvc.get('token')) config.headers['X-Auth-Token'] = CookieSrvc.get('token');
				return config;
			}
			
			return Interceptor;
		}
		
		Interceptor.$inject = ['CookieSrvc'];	
	
})();