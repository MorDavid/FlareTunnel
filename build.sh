#!/bin/bash
# Build script for FlareTunnel Go version

set -e

echo "🔨 Building FlareTunnel..."

# Get dependencies
echo "📦 Downloading dependencies..."
go mod download

# Detect current platform
GOOS=$(go env GOOS)

# Detect architecture using system detection (more reliable on macOS)
SYSTEM_ARCH=$(uname -m)
case "$SYSTEM_ARCH" in
    x86_64|amd64)
        GOARCH="amd64"
        ;;
    aarch64|arm64)
        GOARCH="arm64"
        ;;
    armv7l)
        GOARCH="arm"
        ;;
    *)
        # Fallback to Go's detection
        GOARCH=$(go env GOARCH)
        ;;
esac

# Set binary name for current platform (simple name for ease of use)
BINARY_NAME="FlareTunnel"
if [ "$GOOS" = "windows" ]; then
    BINARY_NAME="FlareTunnel.exe"
fi

# Build for current platform
echo "🏗️  Building for current platform ($GOOS/$GOARCH)..."

GOOS=$GOOS GOARCH=$GOARCH go build -ldflags="-s -w" -o FlareTunnel FlareTunnel.go

echo "✅ Build complete: ./$BINARY_NAME"
echo ""
echo "📊 Binary size:"
ls -lh "$BINARY_NAME" | awk '{print $5}'
echo ""
echo "🚀 Quick start:"
echo "  ./$BINARY_NAME config          # Configure accounts"
echo "  ./$BINARY_NAME create --count 5   # Create workers"
echo "  ./$BINARY_NAME list --verbose     # List workers"
echo "  ./$BINARY_NAME tunnel --verbose   # Start proxy"
echo ""

# Optional: Build for other platforms
read -p "Build for other platforms? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "🌍 Building for multiple platforms..."
    
    # Windows
    echo "  Building for Windows (amd64)..."
    GOOS=windows GOARCH=amd64 go build -ldflags="-s -w" -o flaretunnel-windows-amd64.exe FlareTunnel.go
    
    # Linux
    echo "  Building for Linux (amd64)..."
    GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o flaretunnel-linux-amd64 FlareTunnel.go
    
    # macOS Intel
    echo "  Building for macOS (amd64)..."
    GOOS=darwin GOARCH=amd64 go build -ldflags="-s -w" -o flaretunnel-macos-amd64 FlareTunnel.go
    
    # macOS Apple Silicon
    echo "  Building for macOS (arm64)..."
    GOOS=darwin GOARCH=arm64 go build -ldflags="-s -w" -o flaretunnel-macos-arm64 FlareTunnel.go
    
    # Linux ARM (Raspberry Pi, etc.)
    echo "  Building for Linux (arm64)..."
    GOOS=linux GOARCH=arm64 go build -ldflags="-s -w" -o flaretunnel-linux-arm64 FlareTunnel.go
    
    echo ""
    echo "✅ Cross-compilation complete!"
    echo ""
    echo "📦 Built binaries:"
    ls -lh flaretunnel-* | awk '{print "  " $9 " - " $5}'
    echo ""
fi

echo "✨ Done!"

