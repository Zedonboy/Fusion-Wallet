

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.D6BxvXkA.js","_app/immutable/chunks/B2QSKqcC.js","_app/immutable/chunks/hu_NsNWv.js","_app/immutable/chunks/3pqYDxjW.js"];
export const stylesheets = [];
export const fonts = [];
