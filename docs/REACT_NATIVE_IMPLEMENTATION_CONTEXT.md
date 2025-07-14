# React Native Implementation Context & Todo Management

## Overview
This document provides the complete context needed to continue the React Native implementation on a Mac machine. It includes the todo list, memory keys, and implementation approach.

## Current Todo List (25 Tasks)

### High Priority Tasks (Must Complete First)
1. **rn-1**: Initialize React Native project with TypeScript template
2. **rn-2**: Install core navigation dependencies (@react-navigation/native, @react-navigation/native-stack)
3. **rn-3**: Install iOS-specific dependencies and run pod install
4. **rn-4**: Set up project structure (components, services, navigation, utils)
5. **rn-5**: Implement secure storage service using react-native-keychain
6. **rn-6**: Create backend configuration screen for URL input
7. **rn-7**: Implement authentication flow with JWT token storage
8. **rn-8**: Set up WebSocket manager with reconnection logic
9. **rn-9**: Create main navigation structure (Auth, Main, Settings stacks)
10. **rn-10**: Migrate login screen UI to React Native components
11. **rn-12**: Create chat interface with native ScrollView and TextInput
12. **rn-17**: Configure iOS AppDelegate for deep linking
13. **rn-18**: Set up Info.plist for network permissions
14. **rn-21**: Create Xcode build configurations (Debug/Release)
15. **rn-22**: Test on iOS simulator with Docker backend
16. **rn-23**: Test on physical iOS device

### Medium Priority Tasks
17. **rn-11**: Implement project list screen with FlatList
18. **rn-13**: Implement message rendering with syntax highlighting
19. **rn-14**: Add file browser component with tree view
20. **rn-15**: Create MCP server management UI
21. **rn-16**: Implement tools settings screen
22. **rn-19**: Implement biometric authentication support
23. **rn-24**: Optimize performance and memory usage

### Low Priority Tasks
24. **rn-20**: Add push notification support
25. **rn-25**: Prepare for TestFlight/App Store submission

## Memory Search Context

### React Native Implementation Patterns to Store/Retrieve

```typescript
// Key patterns to search for in mem0:

// Navigation patterns
const navigationKeys = [
  'react-native-navigation-setup',
  'react-navigation-typescript-config',
  'navigation-auth-flow-pattern',
  'deep-linking-ios-setup'
];

// Security & Storage
const securityKeys = [
  'react-native-keychain-implementation',
  'jwt-secure-storage-pattern',
  'biometric-auth-ios-implementation',
  'backend-url-dynamic-config'
];

// WebSocket patterns
const websocketKeys = [
  'react-native-websocket-reconnection',
  'websocket-auth-token-handling',
  'websocket-message-queue-pattern',
  'mobile-network-state-handling'
];

// iOS specific
const iosKeys = [
  'ios-info-plist-network-config',
  'ios-app-transport-security',
  'xcode-build-settings-production',
  'ios-push-notification-setup'
];

// Claude Code UI specific
const claudeCodeKeys = [
  'claudecode-api-endpoints',
  'claudecode-websocket-protocol',
  'claudecode-mcp-server-detection',
  'claudecode-project-structure'
];
```

## Implementation Approach

### Phase 1: Core Setup (Tasks rn-1 to rn-4)
```bash
# Execute on Mac after cloning
cd /path/to/claudecodeui
./scripts/execute-react-native-conversion.sh
```

### Phase 2: Security & Storage (Tasks rn-5 to rn-7)
Key implementation files created by script:
- `mobile/ClaudeCodeMobile/src/services/storage/secureStorage.ts`
- `mobile/ClaudeCodeMobile/src/services/api/apiClient.ts`

### Phase 3: Real-time Communication (Task rn-8)
WebSocket manager with:
- Automatic reconnection
- Exponential backoff
- Message queuing
- Network state handling

### Phase 4: Navigation (Tasks rn-9 to rn-10)
Navigation structure:
```
AppNavigator
├── BackendConfigScreen (if not configured)
├── AuthNavigator (if not authenticated)
│   └── LoginScreen
└── MainNavigator (authenticated)
    ├── ProjectListScreen
    ├── ChatScreen
    └── SettingsScreen
```

### Phase 5: iOS Configuration (Tasks rn-17, rn-18, rn-21)
Critical iOS settings:
- NSAppTransportSecurity for local backend
- NSFaceIDUsageDescription for biometrics
- Keychain sharing capabilities

## Research Requirements for Mac Implementation

### Before Starting Each Task:

1. **Search mem0 for existing patterns**
   ```
   Example: When implementing rn-5 (secure storage)
   - Search: "react-native-keychain-implementation"
   - Search: "ios-keychain-best-practices"
   - Search: "jwt-token-secure-storage"
   ```

2. **Use Context7 for latest documentation**
   ```
   Example: For rn-2 (navigation setup)
   - Query: "@react-navigation/native latest setup"
   - Query: "react navigation typescript configuration"
   ```

3. **Store all findings in mem0**
   ```
   Example: After implementing rn-8 (WebSocket)
   - Store: Working reconnection pattern
   - Store: iOS background handling approach
   - Store: Network state monitoring solution
   ```

## Critical Implementation Notes

### Backend Configuration (rn-6)
- Must allow user to input backend URL
- Store in Keychain, not AsyncStorage
- Test connection before saving
- Support both HTTP and HTTPS

### Authentication Flow (rn-7)
- JWT stored in Keychain
- Refresh token handling
- Biometric authentication as option
- Session persistence across app launches

### WebSocket Implementation (rn-8)
- Handle app backgrounding
- Queue messages when disconnected
- Automatic reconnection with backoff
- Clear connection on logout

### iOS Specific Considerations
- Test on real devices (not just simulator)
- Handle iOS 13+ dark mode
- Implement haptic feedback
- Use native iOS UI patterns

## Testing Checklist for Each Task

### Development Testing
- [ ] Runs on iOS Simulator
- [ ] No TypeScript errors
- [ ] No console warnings
- [ ] Memory usage acceptable

### Integration Testing
- [ ] Connects to Docker backend
- [ ] Handles network failures gracefully
- [ ] Data persists correctly
- [ ] Navigation works as expected

### Production Testing
- [ ] Runs on physical iPhone
- [ ] Performance is smooth (60fps)
- [ ] No crashes or hangs
- [ ] All features work end-to-end

## File Structure Created by Script

```
mobile/ClaudeCodeMobile/
├── src/
│   ├── components/
│   │   ├── auth/
│   │   ├── chat/
│   │   ├── projects/
│   │   ├── settings/
│   │   └── common/
│   ├── navigation/
│   ├── services/
│   │   ├── api/
│   │   │   └── apiClient.ts
│   │   ├── websocket/
│   │   │   └── WebSocketManager.ts
│   │   └── storage/
│   │       └── secureStorage.ts
│   ├── utils/
│   └── types/
├── ios/
│   └── ClaudeCodeMobile/
│       └── Info.plist (configured)
└── package.json
```

## Commands for Mac Development

```bash
# After cloning and setup
cd mobile/ClaudeCodeMobile

# Install dependencies
npm install

# iOS specific
cd ios && pod install && cd ..

# Start Metro
npx react-native start

# Run on iOS
npx react-native run-ios

# Run on specific simulator
npx react-native run-ios --simulator="iPhone 15 Pro"

# Build for release
npx react-native run-ios --configuration Release
```

## Next Steps on Mac

1. Clone repository and checkout `feature/react-native` branch
2. Run the setup script: `./scripts/execute-react-native-conversion.sh`
3. Start working through todos in order (rn-1 through rn-25)
4. Search mem0 for patterns before implementing each feature
5. Test with real Docker backend (no mocks)
6. Store all learnings back to mem0
7. Commit progress frequently

---

*This context should be loaded when starting React Native implementation on Mac*
*All todos and implementation details are included for seamless continuation*