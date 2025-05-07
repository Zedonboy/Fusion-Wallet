# Copyright (C) 2025 Fusion Wallet
# 
# This file is part of Fusion Wallet.
# 
# Fusion Wallet is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# Fusion Wallet is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with Fusion Wallet.  If not, see <https://www.gnu.org/licenses/>.
npm run prod-build
flutter_rust_bridge_codegen generate
flutter_rust_bridge_codegen build-web --release
flutter_rust_bridge_codegen build-web --output ../onchain_web --release
flutter build web
# Rename web folder to webX
mv web webX

# Rename onchain_web to web
mv onchain_web web

# Build with the specified parameters
flutter build web -o build/onchain_web --dart-define=ONCHAIN_WEB=true

# Reverse the renaming
mv web onchain_web
mv webX web