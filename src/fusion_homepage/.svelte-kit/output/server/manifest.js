export const manifest = (() => {
function __memo(fn) {
	let value;
	return () => value ??= (value = fn());
}

return {
	appDir: "_app",
	appPath: "_app",
	assets: new Set([".ic-assets.json5",".well-known/ic-domains","built_on.png","favicon.ico","fusion_home_rec.png","fusion_receive_ss.png","fusion_web_logo.png","google62bff15620e472a3.html","logo2.svg"]),
	mimeTypes: {".json5":"application/json5",".png":"image/png",".html":"text/html",".svg":"image/svg+xml"},
	_: {
		client: {start:"_app/immutable/entry/start.CYPCDB4j.js",app:"_app/immutable/entry/app.DcXvt3X-.js",imports:["_app/immutable/entry/start.CYPCDB4j.js","_app/immutable/chunks/wM96HzQM.js","_app/immutable/chunks/B2QSKqcC.js","_app/immutable/entry/app.DcXvt3X-.js","_app/immutable/chunks/B2QSKqcC.js","_app/immutable/chunks/hu_NsNWv.js"],stylesheets:[],fonts:[],uses_env_dynamic_public:false},
		nodes: [
			__memo(() => import('./nodes/0.js')),
			__memo(() => import('./nodes/1.js'))
		],
		routes: [
			
		],
		prerendered_routes: new Set(["/"]),
		matchers: async () => {
			
			return {  };
		},
		server_assets: {}
	}
}
})();
