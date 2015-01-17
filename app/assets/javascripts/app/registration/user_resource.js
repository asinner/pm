(function() {
	
	'use strict';
	
	angular.module('projectManagement')
		.factory('User', User);
		
		function User($resource, API_BASE) {
			return $resource(API_BASE + '/users/:id', { id: '@id' }, {
				'query': { method: 'GET', isArray: false },
				'update': { method: 'PATCH' }
			});
		}
		
		User.$inject = ['$resource', 'API_BASE']
	
})();