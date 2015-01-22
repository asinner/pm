(function() {
	
	'use strict';
	
	angular.module('projectManagement')
		.factory('Company', Company);
		
		function Company($resource, API_BASE) {
			return $resource(API_BASE + '/companies/:id', {id: '@id'}, {
				'query': {method: 'GET', isArray: false},
				'update': {method: 'PATCH'}
			});
		}
		
		Company.$inject = ['$resource', 'API_BASE'];
	
})();