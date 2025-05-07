/**
 * Copyright (C) 2025 Fusion Wallet
 * 
 * This file is part of Fusion Wallet.
 * 
 * Fusion Wallet is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Fusion Wallet is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with Fusion Wallet.  If not, see <https://www.gnu.org/licenses/>.
 */

// webpack.config.js
const path = require('path');
const webpack = require('webpack');
const dotenv = require('dotenv');
const Dotenv = require('dotenv-webpack');

// Load environment variables from .env file
// const env = dotenv.config().parsed || {};

module.exports = {
  entry: './src/index.js',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'onchain_web')
  },
  plugins: [
    // new webpack.DefinePlugin({
    //   'process.env': JSON.stringify(process.env),
    //   // Or use the specific environment variables you loaded
    //   // ...envKeys
    // }),
    new Dotenv({
      path: './.env', // Path to .env file (default)
      safe: false, // load .env.example (defaults to "false")
      systemvars: true, // load all system variables as well (useful for CI purposes)
      defaults: false // load .env.defaults as the default values if empty
    }),
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV || 'development')
    }),
  ],
  mode: 'production' // or 'development',

};