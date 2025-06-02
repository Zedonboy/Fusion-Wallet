

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.COTd7fdz.js","_app/immutable/chunks/B2QSKqcC.js","_app/immutable/chunks/hu_NsNWv.js"];
export const stylesheets = ["_app/immutable/assets/2.BQvPT34o.css"];
export const fonts = [];
