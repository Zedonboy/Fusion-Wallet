import { defineConfig } from 'vite'
import { resolve } from 'path'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  build: {
    lib: {
      entry: resolve(__dirname, 'index.ts'),
      name: 'FusionConnect',
      fileName: (format) => `fusion-connect.${format}.js`
    },
    rollupOptions: {
      external: ['qrcode-generator', 'libp2p', '@libp2p/websockets', '@libp2p/webrtc', 
                '@chainsafe/libp2p-noise', '@chainsafe/libp2p-yamux', '@libp2p/interface',
                '@libp2p/circuit-relay-v2', '@libp2p/identify', '@libp2p/bootstrap',
                '@multiformats/multiaddr-matcher', 'it-length-prefixed-stream', '@libp2p/ping',
                'cbor', '@dfinity/identity', '@libp2p/tcp'],
      output: {
        globals: {
          'qrcode-generator': 'qrcode',
          'libp2p': 'libp2p',
          '@dfinity/identity': 'dfinity.identity'
          // Add other globals as needed
        }
      }
    },
    cssCodeSplit: true
  },
  plugins: [
    tailwindcss(),
  ],
}) 