(function() {
	
	'use strict';
	
	angular.module('projectManagement')
		.controller('RegistrationCtrl', RegistrationCtrl);

		function RegistrationCtrl(User) {
			var vm = this;
			vm.user = {};
			vm.create = create;
			
			function create(user) {
				console.log(user);
				var user = new User(user);
				user.$save(user).then(success, error);
					
				function success(response) {
					
				}
				function error(response) {
					
				}
			}
		}
		
		RegistrationCtrl.$inject = ['User'];
	
})();