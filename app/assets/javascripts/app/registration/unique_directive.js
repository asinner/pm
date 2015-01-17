(function() {
	
	'use strict';
	
	angular.module('projectManagement')
		.directive('unique', unique);
		
		function unique($q, $timeout, UserSrvc) {
		  return {
		    require: 'ngModel',
		    link: function(scope, elm, attrs, ctrl) {
		      ctrl.$asyncValidators.unique = function(modelValue) {
		      	if (ctrl.$isEmpty(modelValue)) return $q.when();
		        var def = $q.defer();
	 					$timeout(function() {
							UserSrvc.checkEmailUniqueness(modelValue)
								.then(success, error);
								function success() {
									def.reject();
								}
								function error() {
									def.resolve();
								}
		        }, 200);
		        return def.promise;
		      };
		    }	
			}
		};

		unique.$inject = ['$q', '$timeout', 'UserSrvc'];
		
})();