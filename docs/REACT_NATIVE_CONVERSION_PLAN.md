# React Native Conversion Plan for Claude Code UI

## Overview
This document outlines the comprehensive plan to convert the Claude Code UI web application into a React Native application, initially focusing on iOS platform support. The application will maintain its existing backend infrastructure while providing a native mobile experience.

## Architecture Design

### High-Level Architecture
```
┌─────────────────────┐     ┌─────────────────────┐     ┌─────────────────────┐
│  React Native App   │◄───►│  Backend (Docker)   │◄───►│   Claude CLI        │
│  (iOS/Android)      │     │  Express + WS       │     │                     │
├─────────────────────┤     ├─────────────────────┤     └─────────────────────┘
│ - Native UI         │     │ - Auth API          │
│ - Navigation        │     │ - WebSocket Server  │
│ - Secure Storage    │     │ - File Operations   │
│ - Backend Config    │     │ - Git Integration   │
└─────────────────────┘     └─────────────────────┘

Communication: HTTP/WebSocket over configurable URL
```

### Key Architectural Changes
1. **Separation of Concerns**: Mobile app as pure client, backend remains containerized
2. **Dynamic Backend Configuration**: User configures backend URL on first launch
3. **Secure Credential Storage**: JWT tokens stored in iOS Keychain
4. **Native Navigation**: React Navigation with native stack navigator
5. **WebSocket Management**: Native WebSocket API with reconnection logic

## Phase 1: Project Setup and Core Infrastructure

### 1.1 Initialize React Native Project
```bash
npx react-native init ClaudeCodeMobile --template react-native-template-typescript
cd ClaudeCodeMobile
```

### 1.2 Install Core Dependencies
```bash
# Navigation
npm install @react-navigation/native @react-navigation/native-stack
npm install react-native-screens react-native-safe-area-context

# Secure Storage
npm install react-native-keychain

# UI Components
npm install react-native-vector-icons
npm install react-native-paper

# Utilities
npm install react-native-config
npm install react-native-device-info

# iOS specific
cd ios && pod install
```

### 1.3 Project Structure
```
ClaudeCodeMobile/
├── src/
│   ├── components/
│   │   ├── auth/
│   │   │   ├── LoginScreen.tsx
│   │   │   └── BackendConfigScreen.tsx
│   │   ├── chat/
│   │   │   ├── ChatInterface.tsx
│   │   │   ├── MessageList.tsx
│   │   │   └── MessageInput.tsx
│   │   ├── projects/
│   │   │   ├── ProjectList.tsx
│   │   │   └── ProjectSelector.tsx
│   │   ├── settings/
│   │   │   ├── ToolsSettings.tsx
│   │   │   └── MCPServers.tsx
│   │   └── common/
│   │       ├── LoadingScreen.tsx
│   │       └── ErrorBoundary.tsx
│   ├── navigation/
│   │   ├── AppNavigator.tsx
│   │   ├── AuthNavigator.tsx
│   │   └── MainNavigator.tsx
│   ├── services/
│   │   ├── api/
│   │   │   ├── apiClient.ts
│   │   │   ├── auth.ts
│   │   │   ├── projects.ts
│   │   │   └── mcp.ts
│   │   ├── websocket/
│   │   │   ├── WebSocketManager.ts
│   │   │   └── messageHandlers.ts
│   │   └── storage/
│   │       ├── secureStorage.ts
│   │       └── appStorage.ts
│   ├── utils/
│   │   ├── constants.ts
│   │   └── helpers.ts
│   └── App.tsx
├── ios/
│   └── ClaudeCodeMobile/
│       ├── AppDelegate.mm
│       └── Info.plist
└── android/
```

## Phase 2: Authentication and Backend Configuration

### 2.1 Backend Configuration Flow
1. **First Launch Detection**
   - Check Keychain for stored backend URL
   - If not found, show configuration screen

2. **Backend Configuration Screen**
   ```typescript
   interface BackendConfig {
     url: string;
     wsUrl: string;
     isSecure: boolean;
   }
   ```
   - Input field for backend URL (e.g., `http://192.168.1.100:2008`)
   - Test connection button
   - Save to Keychain on success

### 2.2 Authentication Implementation
```typescript
// secureStorage.ts
import * as Keychain from 'react-native-keychain';

export const SecureStorage = {
  async setToken(token: string): Promise<void> {
    await Keychain.setInternetCredentials(
      'claudecode-backend',
      'jwt-token',
      token
    );
  },
  
  async getToken(): Promise<string | null> {
    const credentials = await Keychain.getInternetCredentials('claudecode-backend');
    return credentials ? credentials.password : null;
  },
  
  async setBackendUrl(url: string): Promise<void> {
    await Keychain.setInternetCredentials(
      'claudecode-config',
      'backend-url',
      url
    );
  }
};
```

### 2.3 Login Flow
1. Get backend URL from Keychain
2. Present login screen
3. Authenticate with backend
4. Store JWT token in Keychain
5. Navigate to main app

## Phase 3: Core UI Components Migration

### 3.1 Navigation Structure
```typescript
// AppNavigator.tsx
const Stack = createNativeStackNavigator();

export const AppNavigator = () => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [isConfigured, setIsConfigured] = useState(false);

  return (
    <NavigationContainer>
      <Stack.Navigator>
        {!isConfigured ? (
          <Stack.Screen name="BackendConfig" component={BackendConfigScreen} />
        ) : !isAuthenticated ? (
          <Stack.Screen name="Login" component={LoginScreen} />
        ) : (
          <>
            <Stack.Screen name="Main" component={MainScreen} />
            <Stack.Screen name="Chat" component={ChatScreen} />
            <Stack.Screen name="Settings" component={SettingsScreen} />
          </>
        )}
      </Stack.Navigator>
    </NavigationContainer>
  );
};
```

### 3.2 Chat Interface Adaptation
- Convert HTML/CSS to React Native StyleSheet
- Replace div/span with View/Text components
- Implement native ScrollView for messages
- Use KeyboardAvoidingView for input handling
- Native TextInput with multiline support

### 3.3 WebSocket Integration
```typescript
// WebSocketManager.ts
export class WebSocketManager {
  private ws: WebSocket | null = null;
  private url: string;
  private reconnectAttempts = 0;
  
  constructor(url: string) {
    this.url = url;
  }
  
  connect(token: string) {
    this.ws = new WebSocket(`${this.url}?token=${token}`);
    
    this.ws.onopen = () => {
      console.log('WebSocket connected');
      this.reconnectAttempts = 0;
    };
    
    this.ws.onmessage = (event) => {
      this.handleMessage(JSON.parse(event.data));
    };
    
    this.ws.onerror = (error) => {
      console.error('WebSocket error:', error);
    };
    
    this.ws.onclose = () => {
      this.handleReconnect();
    };
  }
  
  private handleReconnect() {
    if (this.reconnectAttempts < 5) {
      setTimeout(() => {
        this.reconnectAttempts++;
        this.connect();
      }, 1000 * Math.pow(2, this.reconnectAttempts));
    }
  }
}
```

## Phase 4: iOS-Specific Implementation

### 4.1 AppDelegate Configuration
```objc
// AppDelegate.mm
#import <React/RCTLinkingManager.h>

- (BOOL)application:(UIApplication *)application
   openURL:(NSURL *)url
   options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
  return [RCTLinkingManager application:application openURL:url options:options];
}
```

### 4.2 Info.plist Configuration
```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
  <key>NSExceptionDomains</key>
  <dict>
    <key>localhost</key>
    <dict>
      <key>NSExceptionAllowsInsecureHTTPLoads</key>
      <true/>
    </dict>
  </dict>
</dict>
```

### 4.3 iOS Build Configuration
- Bundle identifier: `com.claudecode.mobile`
- Deployment target: iOS 13.0
- Code signing with development team
- Capability additions: Keychain Sharing (if needed)

## Phase 5: Feature Implementation

### 5.1 Project Management
- Native FlatList for project display
- Swipe actions for project operations
- Pull-to-refresh functionality
- Search/filter implementation

### 5.2 File Browser
- Tree view using recursive components
- File preview with syntax highlighting
- Native share functionality for files

### 5.3 Settings and MCP
- Native switches and pickers
- MCP server configuration UI
- Tool permission management
- Biometric authentication toggle

### 5.4 Native Features
- Push notifications for long operations
- Background task support
- Haptic feedback for interactions
- Native clipboard integration

## Phase 6: Testing Strategy

### 6.1 Development Testing
1. **Simulator Testing**
   ```bash
   # Start Metro bundler
   npx react-native start
   
   # Run on iOS simulator
   npx react-native run-ios --simulator="iPhone 15 Pro"
   ```

2. **Docker Backend Setup**
   ```bash
   # Start backend
   docker-compose -f docker-compose.dev.yml up
   
   # Note container IP for mobile app config
   docker inspect claude-code-ui-dev | grep IPAddress
   ```

3. **Device Testing**
   - Connect iPhone via USB
   - Build to device from Xcode
   - Test with local network backend

### 6.2 Integration Testing
- Test authentication flow
- Verify WebSocket connectivity
- Test file operations
- Validate MCP server detection
- Check offline handling

### 6.3 Performance Testing
- Monitor memory usage
- Profile render performance
- Test with large chat histories
- Optimize list rendering

## Phase 7: Production Build

### 7.1 Release Configuration
```bash
# Clean build
cd ios && rm -rf build && pod install

# Build release
npx react-native run-ios --configuration Release
```

### 7.2 App Store Preparation
- App icons and launch screens
- App Store screenshots
- Privacy policy updates
- Export compliance

### 7.3 Distribution Options
1. **TestFlight Beta**
   - Internal testing group
   - External beta testers
   - Feedback collection

2. **Enterprise Distribution**
   - In-house deployment
   - MDM integration
   - Custom configuration

## Implementation Timeline

### Week 1-2: Foundation
- Project setup and configuration
- Core navigation implementation
- Authentication flow
- Backend configuration UI

### Week 3-4: Core Features
- Chat interface migration
- WebSocket integration
- Project management
- Basic file operations

### Week 5-6: Advanced Features
- MCP server management
- Settings implementation
- File browser
- Native optimizations

### Week 7-8: Testing & Polish
- Comprehensive testing
- Performance optimization
- UI polish and animations
- Bug fixes

### Week 9-10: Release Preparation
- Production builds
- Documentation
- Deployment setup
- Beta testing

## Success Criteria

1. **Functional Parity**
   - All web features available in mobile
   - Reliable WebSocket connection
   - Secure credential storage
   - MCP server detection and management

2. **Performance Metrics**
   - App launch < 2 seconds
   - Smooth 60fps scrolling
   - Memory usage < 200MB
   - Battery efficient operation

3. **User Experience**
   - Native iOS look and feel
   - Intuitive navigation
   - Responsive interactions
   - Offline capability

4. **Security Requirements**
   - Biometric authentication
   - Encrypted credential storage
   - Secure backend communication
   - No credential leakage

## Risks and Mitigations

1. **Network Connectivity**
   - Risk: Unstable connections
   - Mitigation: Robust reconnection logic, offline queue

2. **Performance**
   - Risk: Large chat histories
   - Mitigation: Virtual list rendering, pagination

3. **Security**
   - Risk: Token exposure
   - Mitigation: Keychain storage, certificate pinning

4. **Compatibility**
   - Risk: iOS version fragmentation
   - Mitigation: Target iOS 13+, progressive enhancement

## Next Steps

1. Create feature branch: `feature/react-native`
2. Initialize React Native project
3. Implement backend configuration
4. Build authentication flow
5. Begin UI component migration
6. Set up CI/CD pipeline
7. Start beta testing program

---

*Document Version: 1.0*  
*Last Updated: 2025-01-14*  
*Author: Claude Assistant*