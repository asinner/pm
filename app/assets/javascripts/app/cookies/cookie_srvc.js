(function() {
	
	'use strict';
	
	angular.module('projectManagement')
		.service('CookieSrvc', CookieSrvc);
		
		function CookieSrvc() {
			var CookieSrvc = {};
			
			CookieSrvc.get = get;
			CookieSrvc.set = set;
			CookieSrvc.remove = remove;
			CookieSrvc.has = has;
			CookieSrvc.keys = keys;
			
			function get(sKey) {
				if (!sKey) { return null; }
		    return decodeURIComponent(document.cookie.replace(new RegExp("(?:(?:^|.*;)\\s*" + encodeURIComponent(sKey).replace(/[\-\.\+\*]/g, "\\$&") + "\\s*\\=\\s*([^;]*).*$)|^.*$"), "$1")) || null;
			}
			
			function set(args) {
				if (!args.key || /^(?:expires|max\-age|path|domain|secure)$/i.test(args.key)) { return false; }
		    var sExpires = "";			
				if (args.end) {
					switch (args.end.constructor) {
						case Number:
							sExpires = args.end === Infinity ? "; expires=Fri, 31 Dec 9999 23:59:59 GMT" : "; max-age=" + args.end;
							break;
						case String:
	          	sExpires = "; expires=" + args.end;
							break;
						case Date:
	          	sExpires = "; expires=" + args.end.toUTCString();
							break;
					}
				}
				document.cookie = encodeURIComponent(args.key) + "=" + encodeURIComponent(args.value) + sExpires + (args.domain ? "; domain=" + args.domain : "") + (args.path ? "; path=" + args.path : "") + (args.secure ? "; secure" : "");
		    return true;
			}
			
			function remove(sKey, sPath, sDomain) {
				if (!this.has(sKey)) { return false; }
		    document.cookie = encodeURIComponent(sKey) + "=; expires=Thu, 01 Jan 1970 00:00:00 GMT" + (sDomain ? "; domain=" + sDomain : "") + (sPath ? "; path=" + sPath : "");
		    return true;
			}

			function has(sKey) {
				if (!sKey) { return false; }
		    return (new RegExp("(?:^|;\\s*)" + encodeURIComponent(sKey).replace(/[\-\.\+\*]/g, "\\$&") + "\\s*\\=")).test(document.cookie);
			}

			function keys() {
				var aKeys = document.cookie.replace(/((?:^|\s*;)[^\=]+)(?=;|$)|^\s*|\s*(?:\=[^;]*)?(?:\1|$)/g, "").split(/\s*(?:\=[^;]*)?;\s*/);
		    for (var nLen = aKeys.length, nIdx = 0; nIdx < nLen; nIdx++) { aKeys[nIdx] = decodeURIComponent(aKeys[nIdx]); }
		    return aKeys;
			}

			return CookieSrvc;
		}
		
		CookieSrvc.$inject = [];
	
})();