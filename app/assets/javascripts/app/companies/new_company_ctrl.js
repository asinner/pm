(function() {
	
	'use strict';
	
	angular.module('projectManagement')
		.controller('NewCompanyCtrl', NewCompanyCtrl);
		
		function NewCompanyCtrl($location, Company) {
			var vm = this;
			vm.model = {};
			
			vm.create = create;
			
			function create(vmCompany) {
				vm.loading = true;
				var company = new Company(vmCompany);
				company.$save().then(function(response) {
					$location.path('/team/add')
				});
			}
			
		}
		
		NewCompanyCtrl.$inject = ['$location', 'Company'];
	
})();