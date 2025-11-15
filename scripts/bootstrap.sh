#
//  bootstrap.sh
//  
//
//  Created by Katie Richman on 11/14/25.
//

#!/usr/bin/env bash

set -e

echo "🔧 Bootstrapping Contextual workspace..."

# 1. Ensure base directory exists
mkdir -p ~/04_Developer
cd ~/04_Developer

# 2. Clone repo if missing
if [ ! -d "Contextual" ]; then
  echo "📦 Cloning repository..."
  git clone git@github.com:loudkatie/Contextual.git
else
  echo "👍 Repository already present. Pulling latest..."
  cd Contextual
  git pull origin main
fi

cd Contextual

# 3. Prepare folders (idempotent)
mkdir -p docs/product
mkdir -p docs/design
mkdir -p docs/technical
mkdir -p docs/operations

mkdir -p ios/ContextualApp/Sources/App
mkdir -p ios/ContextualApp/Sources/Views
mkdir -p ios/ContextualApp/Sources/Services
mkdir -p ios/ContextualApp/Sources/Models

mkdir -p ios/ContextualApp/Resources/Assets
mkdir -p ios/ContextualApp/Resources/Sounds

mkdir -p scripts

# 4. Generate Xcode project if XcodeGen is available
if command -v xcodegen >/dev/null 2>&1; then
  echo "🛠️  XcodeGen found — regenerating project..."
  xcodegen generate
else
  echo "⚠️  XcodeGen not installed. Skipping project generation."
  echo "    Install with: brew install xcodegen"
fi

echo "🎉 Bootstrap complete!"
