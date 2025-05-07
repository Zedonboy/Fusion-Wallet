// vite.config.js
import { fileURLToPath, URL } from "url";
import { sveltekit } from "file:///home/declan/Desktop/Dev/fusion_repo/fusion_wallet_web/node_modules/@sveltejs/kit/src/exports/vite/index.js";
import { defineConfig } from "file:///home/declan/Desktop/Dev/fusion_repo/fusion_wallet_web/node_modules/vite/dist/node/index.js";
import environment from "file:///home/declan/Desktop/Dev/fusion_repo/fusion_wallet_web/node_modules/vite-plugin-environment/dist/index.js";
import dotenv from "file:///home/declan/Desktop/Dev/fusion_repo/fusion_wallet_web/node_modules/dotenv/lib/main.js";
import tailwindcss from "file:///home/declan/Desktop/Dev/fusion_repo/fusion_wallet_web/node_modules/@tailwindcss/vite/dist/index.mjs";
var __vite_injected_original_import_meta_url = "file:///home/declan/Desktop/Dev/fusion_repo/fusion_wallet_web/src/fusion_wallet_frontend/vite.config.js";
dotenv.config({ path: "../../.env" });
var vite_config_default = defineConfig({
  build: {
    emptyOutDir: true
  },
  optimizeDeps: {
    esbuildOptions: {
      define: {
        global: "globalThis"
      }
    }
  },
  server: {
    proxy: {
      "/api": {
        target: "http://127.0.0.1:4943",
        changeOrigin: true
      }
    }
  },
  plugins: [
    tailwindcss(),
    sveltekit(),
    environment("all", { prefix: "CANISTER_" }),
    environment("all", { prefix: "DFX_" })
  ],
  resolve: {
    alias: [
      {
        find: "declarations",
        replacement: fileURLToPath(
          new URL("../declarations", __vite_injected_original_import_meta_url)
        )
      }
    ],
    dedupe: ["@dfinity/agent"]
  }
});
export {
  vite_config_default as default
};
//# sourceMappingURL=data:application/json;base64,ewogICJ2ZXJzaW9uIjogMywKICAic291cmNlcyI6IFsidml0ZS5jb25maWcuanMiXSwKICAic291cmNlc0NvbnRlbnQiOiBbImNvbnN0IF9fdml0ZV9pbmplY3RlZF9vcmlnaW5hbF9kaXJuYW1lID0gXCIvaG9tZS9kZWNsYW4vRGVza3RvcC9EZXYvZnVzaW9uX3JlcG8vZnVzaW9uX3dhbGxldF93ZWIvc3JjL2Z1c2lvbl93YWxsZXRfZnJvbnRlbmRcIjtjb25zdCBfX3ZpdGVfaW5qZWN0ZWRfb3JpZ2luYWxfZmlsZW5hbWUgPSBcIi9ob21lL2RlY2xhbi9EZXNrdG9wL0Rldi9mdXNpb25fcmVwby9mdXNpb25fd2FsbGV0X3dlYi9zcmMvZnVzaW9uX3dhbGxldF9mcm9udGVuZC92aXRlLmNvbmZpZy5qc1wiO2NvbnN0IF9fdml0ZV9pbmplY3RlZF9vcmlnaW5hbF9pbXBvcnRfbWV0YV91cmwgPSBcImZpbGU6Ly8vaG9tZS9kZWNsYW4vRGVza3RvcC9EZXYvZnVzaW9uX3JlcG8vZnVzaW9uX3dhbGxldF93ZWIvc3JjL2Z1c2lvbl93YWxsZXRfZnJvbnRlbmQvdml0ZS5jb25maWcuanNcIjtpbXBvcnQgeyBmaWxlVVJMVG9QYXRoLCBVUkwgfSBmcm9tICd1cmwnO1xuaW1wb3J0IHsgc3ZlbHRla2l0IH0gZnJvbSAnQHN2ZWx0ZWpzL2tpdC92aXRlJztcbmltcG9ydCB7IGRlZmluZUNvbmZpZyB9IGZyb20gJ3ZpdGUnO1xuaW1wb3J0IGVudmlyb25tZW50IGZyb20gJ3ZpdGUtcGx1Z2luLWVudmlyb25tZW50JztcbmltcG9ydCBkb3RlbnYgZnJvbSAnZG90ZW52JztcbmltcG9ydCB0YWlsd2luZGNzcyBmcm9tICdAdGFpbHdpbmRjc3Mvdml0ZSdcblxuZG90ZW52LmNvbmZpZyh7IHBhdGg6ICcuLi8uLi8uZW52JyB9KTtcblxuZXhwb3J0IGRlZmF1bHQgZGVmaW5lQ29uZmlnKHtcbiAgYnVpbGQ6IHtcbiAgICBlbXB0eU91dERpcjogdHJ1ZSxcbiAgfSxcbiAgb3B0aW1pemVEZXBzOiB7XG4gICAgZXNidWlsZE9wdGlvbnM6IHtcbiAgICAgIGRlZmluZToge1xuICAgICAgICBnbG9iYWw6IFwiZ2xvYmFsVGhpc1wiLFxuICAgICAgfSxcbiAgICB9LFxuICB9LFxuICBzZXJ2ZXI6IHtcbiAgICBwcm94eToge1xuICAgICAgXCIvYXBpXCI6IHtcbiAgICAgICAgdGFyZ2V0OiBcImh0dHA6Ly8xMjcuMC4wLjE6NDk0M1wiLFxuICAgICAgICBjaGFuZ2VPcmlnaW46IHRydWUsXG4gICAgICB9LFxuICAgIH0sXG4gIH0sXG4gIHBsdWdpbnM6IFtcbiAgICB0YWlsd2luZGNzcygpLFxuICAgIHN2ZWx0ZWtpdCgpLFxuICAgIGVudmlyb25tZW50KFwiYWxsXCIsIHsgcHJlZml4OiBcIkNBTklTVEVSX1wiIH0pLFxuICAgIGVudmlyb25tZW50KFwiYWxsXCIsIHsgcHJlZml4OiBcIkRGWF9cIiB9KSxcbiAgXSxcbiAgcmVzb2x2ZToge1xuICAgIGFsaWFzOiBbXG4gICAgICB7XG4gICAgICAgIGZpbmQ6IFwiZGVjbGFyYXRpb25zXCIsXG4gICAgICAgIHJlcGxhY2VtZW50OiBmaWxlVVJMVG9QYXRoKFxuICAgICAgICAgIG5ldyBVUkwoXCIuLi9kZWNsYXJhdGlvbnNcIiwgaW1wb3J0Lm1ldGEudXJsKVxuICAgICAgICApLFxuICAgICAgfSxcbiAgICBdLFxuICAgIGRlZHVwZTogWydAZGZpbml0eS9hZ2VudCddLFxuICB9LFxufSk7XG4iXSwKICAibWFwcGluZ3MiOiAiO0FBQXFhLFNBQVMsZUFBZSxXQUFXO0FBQ3hjLFNBQVMsaUJBQWlCO0FBQzFCLFNBQVMsb0JBQW9CO0FBQzdCLE9BQU8saUJBQWlCO0FBQ3hCLE9BQU8sWUFBWTtBQUNuQixPQUFPLGlCQUFpQjtBQUxrUCxJQUFNLDJDQUEyQztBQU8zVCxPQUFPLE9BQU8sRUFBRSxNQUFNLGFBQWEsQ0FBQztBQUVwQyxJQUFPLHNCQUFRLGFBQWE7QUFBQSxFQUMxQixPQUFPO0FBQUEsSUFDTCxhQUFhO0FBQUEsRUFDZjtBQUFBLEVBQ0EsY0FBYztBQUFBLElBQ1osZ0JBQWdCO0FBQUEsTUFDZCxRQUFRO0FBQUEsUUFDTixRQUFRO0FBQUEsTUFDVjtBQUFBLElBQ0Y7QUFBQSxFQUNGO0FBQUEsRUFDQSxRQUFRO0FBQUEsSUFDTixPQUFPO0FBQUEsTUFDTCxRQUFRO0FBQUEsUUFDTixRQUFRO0FBQUEsUUFDUixjQUFjO0FBQUEsTUFDaEI7QUFBQSxJQUNGO0FBQUEsRUFDRjtBQUFBLEVBQ0EsU0FBUztBQUFBLElBQ1AsWUFBWTtBQUFBLElBQ1osVUFBVTtBQUFBLElBQ1YsWUFBWSxPQUFPLEVBQUUsUUFBUSxZQUFZLENBQUM7QUFBQSxJQUMxQyxZQUFZLE9BQU8sRUFBRSxRQUFRLE9BQU8sQ0FBQztBQUFBLEVBQ3ZDO0FBQUEsRUFDQSxTQUFTO0FBQUEsSUFDUCxPQUFPO0FBQUEsTUFDTDtBQUFBLFFBQ0UsTUFBTTtBQUFBLFFBQ04sYUFBYTtBQUFBLFVBQ1gsSUFBSSxJQUFJLG1CQUFtQix3Q0FBZTtBQUFBLFFBQzVDO0FBQUEsTUFDRjtBQUFBLElBQ0Y7QUFBQSxJQUNBLFFBQVEsQ0FBQyxnQkFBZ0I7QUFBQSxFQUMzQjtBQUNGLENBQUM7IiwKICAibmFtZXMiOiBbXQp9Cg==
