# React Native iOS Development Setup Guide for Mac

## Overview
This guide provides comprehensive instructions for setting up the React Native development environment on macOS for the Claude Code UI mobile application. Follow these steps after cloning the `feature/react-native` branch.

## Prerequisites

### 1. System Requirements
- macOS 11.0 (Big Sur) or later
- Xcode 14.0 or later
- At least 10GB of free disk space
- Apple Developer account (for device testing)

### 2. Required Software Installation

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Node.js (v18 or later)
brew install node

# Install Watchman (for file watching)
brew install watchman

# Install CocoaPods
sudo gem install cocoapods

# Install React Native CLI
npm install -g react-native-cli
```

### 3. Xcode Setup
1. Download Xcode from the Mac App Store
2. Open Xcode and accept the license agreement
3. Install additional components when prompted
4. Configure Command Line Tools:
   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   ```

## Memory Search Keys for Context

When starting development on Mac, search mem0 for these keys to retrieve accumulated knowledge:

### React Native Patterns
- `react-native-navigation-patterns`
- `react-native-websocket-implementation`
- `react-native-keychain-usage`
- `react-native-ios-setup`
- `react-native-typescript-config`

### Claude Code UI Specific
- `claudecode-ui-architecture`
- `claudecode-backend-api`
- `claudecode-websocket-protocol`
- `claudecode-authentication-flow`
- `claudecode-mcp-integration`

### iOS Development
- `ios-keychain-security`
- `ios-biometric-authentication`
- `ios-push-notifications`
- `ios-app-transport-security`
- `xcode-build-configuration`

## Project Setup Steps

### 1. Clone and Checkout Branch
```bash
# Clone the repository
git clone https://github.com/yourusername/claudecodeui.git
cd claudecodeui

# Checkout the React Native branch
git checkout feature/react-native
```

### 2. Review Documentation
```bash
# Essential files to review
cat docs/REACT_NATIVE_CONVERSION_PLAN.md
cat .taskmaster/docs/prd.txt
cat scripts/execute-react-native-conversion.sh
```

### 3. Backend Configuration
The mobile app requires the Docker backend to be running. You have two options:

#### Option A: Local Docker Backend
```bash
# Start the backend on your Mac
docker-compose -f docker-compose.dev.yml up -d

# Note the local IP address for mobile configuration
ifconfig | grep "inet " | grep -v 127.0.0.1
```

#### Option B: Remote Docker Backend
- Use the IP address of the machine running the Docker backend
- Ensure ports 2008 (API) and 2008 (WebSocket) are accessible

### 4. Initialize React Native Project
```bash
# Create mobile directory
mkdir mobile
cd mobile

# Initialize React Native with TypeScript
npx react-native init ClaudeCodeMobile --template react-native-template-typescript

# Install core dependencies
cd ClaudeCodeMobile
npm install @react-navigation/native @react-navigation/native-stack
npm install react-native-screens react-native-safe-area-context
npm install react-native-keychain
npm install react-native-vector-icons
npm install react-native-paper

# iOS specific
cd ios && pod install && cd ..
```

## Development Workflow

### 1. Start Metro Bundler
```bash
cd mobile/ClaudeCodeMobile
npx react-native start
```

### 2. Run on iOS Simulator
```bash
# In a new terminal
npx react-native run-ios --simulator="iPhone 15 Pro"
```

### 3. Run on Physical Device
1. Connect your iPhone via USB
2. Open `mobile/ClaudeCodeMobile/ios/ClaudeCodeMobile.xcworkspace` in Xcode
3. Select your device as the build target
4. Click the Run button or press Cmd+R

## Key Implementation Files

### Core Services
- `src/services/storage/secureStorage.ts` - Keychain integration
- `src/services/websocket/WebSocketManager.ts` - Real-time communication
- `src/services/api/apiClient.ts` - Backend API client

### Navigation
- `src/navigation/AppNavigator.tsx` - Main navigation structure
- `src/navigation/AuthNavigator.tsx` - Authentication flow
- `src/navigation/MainNavigator.tsx` - Authenticated app navigation

### Components
- `src/components/auth/BackendConfigScreen.tsx` - Backend URL configuration
- `src/components/auth/LoginScreen.tsx` - User authentication
- `src/components/chat/ChatInterface.tsx` - Main chat UI
- `src/components/projects/ProjectList.tsx` - Project management

## Testing Strategy

### 1. Backend Connection Test
```typescript
// Test backend connectivity
const testBackendConnection = async (url: string) => {
  try {
    const response = await fetch(`${url}/api/health`);
    return response.ok;
  } catch (error) {
    console.error('Backend connection failed:', error);
    return false;
  }
};
```

### 2. WebSocket Testing
```typescript
// Test WebSocket connection
const testWebSocket = (wsUrl: string, token: string) => {
  const ws = new WebSocket(`${wsUrl}?token=${token}`);
  ws.onopen = () => console.log('WebSocket connected');
  ws.onerror = (error) => console.error('WebSocket error:', error);
};
```

### 3. Keychain Testing
```typescript
// Test secure storage
import * as Keychain from 'react-native-keychain';

const testKeychain = async () => {
  await Keychain.setInternetCredentials('test', 'user', 'pass');
  const credentials = await Keychain.getInternetCredentials('test');
  console.log('Keychain test:', credentials);
};
```

## Research Integration Points

### 1. Before Implementation
Query Context7 for latest documentation:
- React Navigation v6 patterns
- React Native 0.73+ changes
- iOS 17 compatibility updates
- Latest security best practices

### 2. During Development
Store discoveries in mem0:
- Working code patterns
- Performance optimizations
- Error solutions
- Integration challenges

### 3. Testing Insights
Document in memory:
- Device-specific issues
- Network configuration solutions
- Build optimization techniques
- Deployment strategies

## Common Issues and Solutions

### 1. Pod Installation Failures
```bash
cd ios
pod deintegrate
pod cache clean --all
pod install
```

### 2. Metro Bundler Cache Issues
```bash
npx react-native start --reset-cache
```

### 3. Build Failures
```bash
cd ios
rm -rf build/
rm -rf ~/Library/Developer/Xcode/DerivedData
```

### 4. Simulator Issues
```bash
xcrun simctl erase all
```

## Production Build Process

### 1. Update Version Numbers
- Update `version` in `package.json`
- Update `CFBundleShortVersionString` in `Info.plist`
- Update `CFBundleVersion` in `Info.plist`

### 2. Create Release Build
```bash
cd ios
xcodebuild -workspace ClaudeCodeMobile.xcworkspace \
  -scheme ClaudeCodeMobile \
  -configuration Release \
  -archivePath ./build/ClaudeCodeMobile.xcarchive \
  archive
```

### 3. Export for TestFlight
- Open Xcode Organizer (Window → Organizer)
- Select the archive
- Click "Distribute App"
- Choose "App Store Connect"
- Follow the upload wizard

## Next Steps

1. **Complete Core Implementation** (Tasks rn-1 through rn-10)
   - Focus on authentication and navigation first
   - Ensure WebSocket connectivity works reliably
   - Test on both simulator and device

2. **Implement Features** (Tasks rn-11 through rn-16)
   - Build feature components incrementally
   - Test each feature with the backend
   - Ensure data persistence works correctly

3. **iOS Platform Integration** (Tasks rn-17 through rn-21)
   - Configure all iOS-specific settings
   - Implement biometric authentication
   - Set up push notifications

4. **Testing and Optimization** (Tasks rn-22 through rn-25)
   - Conduct thorough testing on various devices
   - Profile and optimize performance
   - Prepare for App Store submission

## Important Notes

- Always test with real backend, never mock services
- Store all research findings in mem0 for cross-project learning
- Document every integration pattern that works
- Use Context7 for latest library documentation
- Commit frequently with descriptive messages
- Test on physical devices before marking tasks complete

---

*This guide is part of the React Native conversion project for Claude Code UI*
*Last Updated: 2025-01-14*