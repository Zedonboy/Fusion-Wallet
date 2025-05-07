

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.CZGC3L2D.js","_app/immutable/chunks/B2QSKqcC.js","_app/immutable/chunks/DNLv8VTe.js","_app/immutable/chunks/BtkZg4ET.js"];
export const stylesheets = [];
export const fonts = [];
