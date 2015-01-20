(function() {
	
	'use strict';
	
	angular.module('projectManagement')
		.controller('RegistrationCtrl', RegistrationCtrl);

		function RegistrationCtrl(User, AuthenticationSrvc) {
			var vm = this;
			vm.user = {};
			vm.create = create;
			
			function create(user) {
				vm.loading = true;
				var user = new User(user);
				user.$save(user).then(function(response) {
					AuthenticationSrvc.signIn({
						email: user.email,
						password: user.password
					})
				});
			}
		}
		
		RegistrationCtrl.$inject = ['User', 'AuthenticationSrvc'];
	
})();