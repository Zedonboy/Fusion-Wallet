import tailwindcss from '@tailwindcss/vite';
import { defineConfig } from 'vite';

import { resolve } from 'path';
import { Plugin } from 'vite';

// Custom plugin to handle HTML processing and bundling
function htmlBundlePlugin(): Plugin {
  return {
    name: 'html-bundle-plugin',
    config(config) {
      // Set the build output directory to 'dist'
      return {
        ...config,
        build: {
          ...config.build,
          outDir: 'dist',
          rollupOptions: {
            ...config.build?.rollupOptions,
            input: {
              main: resolve(__dirname, 'index.html'),
              payment: resolve(__dirname, 'payment.html'),
            },
          },
        },
      };
    },
    transformIndexHtml(html) {
      // The entry script will be automatically injected by Vite
      // during the build process with the correct bundle URL
      return html;
    },
  };
}

// Update the config to include the new plugin and specify the entry point
export default defineConfig({
  plugins: [
    tailwindcss(),
    htmlBundlePlugin()
  ],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
    },
  },
  // Define the entry point for the application
  build: {
    sourcemap: true,
    emptyOutDir: true,
  }
});


