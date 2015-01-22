(function() {
	
	'use strict';
	
	angular.module('projectManagement')
		.controller('RegistrationCtrl', RegistrationCtrl);

		function RegistrationCtrl(User, AuthenticationSrvc, $location) {
			var vm = this;
			vm.user = {};
			vm.create = create;
			
			function create(vmUser) {
				vm.loading = true;
				var user = new User(vmUser);
				user.$save().then(function(response) {
					AuthenticationSrvc.signIn({
						email: vmUser.email,
						password: vmUser.password
					}).then(
						function() {
							$location.path('/company/new');
						},
						function() {
							console.log('There seems to be trouble authenticating. However, the account was made so please sign in');
							$location.path('/sign-in');
						}
					)
				});
			}
		}
		
		RegistrationCtrl.$inject = ['User', 'AuthenticationSrvc', '$location'];
	
})();