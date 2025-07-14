# React Native Implementation Guide for Claude Code UI

## Purpose
This guide provides step-by-step instructions for implementing the React Native version of Claude Code UI. It's designed to be read and understood by another Claude instance that will perform the actual implementation on a Mac.

## Prerequisites Knowledge

Before starting, search mem0 for these foundational patterns:
- `React Native Claude Code UI Implementation` - Overview and key decisions
- `React Native Secure Storage Implementation Pattern` - Keychain usage
- `React Native WebSocket Manager Pattern` - Reconnection logic
- `React Native iOS Configuration Requirements` - Info.plist settings
- `Claude Code UI Backend API Integration Pattern` - API endpoints

## Implementation Tasks Overview

We have 25 tasks (rn-1 through rn-25) organized by priority. Each task should be implemented with:
1. Memory search for existing patterns
2. Context7 research for latest documentation
3. Production-grade implementation
4. Real testing (no mocks)
5. Memory storage of new findings

## Task-by-Task Implementation Guide

### Task rn-1: Initialize React Native Project
**Memory Keys**: `react-native-init-typescript`, `react-native-project-structure`
**Research**: Latest React Native CLI setup, TypeScript template
```bash
cd /path/to/claudecodeui
mkdir mobile
cd mobile
npx react-native init ClaudeCodeMobile --template react-native-template-typescript
```

### Task rn-2: Install Navigation Dependencies
**Memory Keys**: `react-navigation-setup`, `react-navigation-typescript`
**Research**: @react-navigation/native v6 setup
```bash
npm install @react-navigation/native @react-navigation/native-stack
npm install react-native-screens react-native-safe-area-context
```

### Task rn-3: iOS Dependencies and Pod Install
**Memory Keys**: `ios-cocoapods-setup`, `react-native-ios-dependencies`
**Research**: CocoaPods compatibility, iOS 13+ requirements
```bash
cd ios
pod install
cd ..
```

### Task rn-4: Project Structure Setup
**Memory Keys**: `react-native-folder-structure`, `typescript-project-organization`
Create this structure:
```
src/
├── components/
│   ├── auth/
│   ├── chat/
│   ├── projects/
│   └── common/
├── navigation/
├── services/
│   ├── api/
│   ├── websocket/
│   └── storage/
├── utils/
└── types/
```

### Task rn-5: Secure Storage Service
**Memory Keys**: `react-native-keychain-implementation`, `jwt-secure-storage`
**Research**: react-native-keychain latest API
**Implementation**: Create `src/services/storage/secureStorage.ts`
- Use pattern from mem0: "React Native Secure Storage Implementation Pattern"
- Store JWT tokens and backend config
- Handle biometric authentication checks

### Task rn-6: Backend Configuration Screen
**Memory Keys**: `react-native-form-input`, `backend-url-validation`
**Research**: TextInput best practices, URL validation
**Implementation**: Create `src/components/auth/BackendConfigScreen.tsx`
- Input for backend URL (e.g., http://192.168.1.100:2008)
- Test connection functionality
- Save to Keychain on success

### Task rn-7: Authentication Flow
**Memory Keys**: `react-native-auth-flow`, `jwt-authentication-pattern`
**Research**: Navigation auth flow, secure token handling
**Implementation**: 
- Login screen with username/password
- JWT token storage in Keychain
- Auto-login on app launch if token valid

### Task rn-8: WebSocket Manager
**Memory Keys**: `react-native-websocket-reconnection`, `websocket-message-queue`
**Research**: React Native WebSocket API, background handling
**Implementation**: Create `src/services/websocket/WebSocketManager.ts`
- Use pattern from mem0: "React Native WebSocket Manager Pattern"
- Automatic reconnection with exponential backoff
- Message queuing when disconnected

### Task rn-9: Navigation Structure
**Memory Keys**: `react-navigation-auth-pattern`, `navigation-typescript-types`
**Research**: Navigation TypeScript setup, conditional navigation
**Implementation**: Create navigation files
- AppNavigator with auth checks
- Conditional rendering based on backend config and auth state

### Task rn-10: Login Screen UI
**Memory Keys**: `react-native-login-ui`, `form-validation-pattern`
**Research**: React Native Paper forms, keyboard handling
**Implementation**: Migrate web login UI to native components
- Use React Native Paper for consistent UI
- KeyboardAvoidingView for input handling

### Tasks rn-11 through rn-25
Continue pattern of:
1. Search relevant memory keys
2. Research latest best practices
3. Implement with production standards
4. Test with real backend
5. Store learnings

## Critical Implementation Details

### Dynamic Backend Configuration
- User MUST input backend URL on first launch
- No hardcoded URLs in the app
- Support both HTTP (local) and HTTPS (production)
- Store in Keychain, not AsyncStorage

### Security Requirements
- All credentials in iOS Keychain
- JWT refresh token handling
- Biometric authentication option
- No sensitive data in logs

### Testing Requirements
- Test on real iOS device, not just simulator
- Verify Docker backend connectivity
- Test offline scenarios
- Performance profiling on device

### iOS Specific Configuration
From mem0 "React Native iOS Configuration Requirements":
- NSAppTransportSecurity for local backend
- NSFaceIDUsageDescription for biometrics
- Bundle ID: com.claudecode.mobile
- Deployment target: iOS 13.0

## Research Sources

### Context7 Queries to Run
1. "@react-navigation/native setup typescript"
2. "react-native-keychain ios implementation"
3. "react native websocket reconnection"
4. "react native ios info.plist configuration"
5. "react native typescript project structure"

### Memory Patterns to Reference
Search mem0 for these exact strings:
- "React Native Secure Storage Implementation Pattern"
- "React Native WebSocket Manager Pattern with Reconnection"
- "React Native iOS Configuration Requirements"
- "Claude Code UI Backend API Integration Pattern"

## Success Criteria

Each task is complete when:
1. Code runs without errors on iOS simulator
2. TypeScript compilation passes
3. Feature works with real Docker backend
4. No console warnings in development
5. Tested on physical iPhone
6. New patterns stored in mem0

## Common Pitfalls to Avoid

1. **Don't use AsyncStorage for sensitive data** - Always use Keychain
2. **Don't mock the backend** - Test with real Docker instance
3. **Don't skip physical device testing** - Simulator isn't enough
4. **Don't hardcode URLs** - Everything must be configurable
5. **Don't ignore TypeScript errors** - Fix them properly

## Next Steps for Implementation

1. Clone the repository and checkout `feature/react-native` branch
2. Read all documentation files thoroughly
3. Search mem0 for all mentioned patterns
4. Start with task rn-1 and proceed in order
5. Document new findings in mem0 for future projects
6. Commit frequently with descriptive messages

Remember: This is a production-grade implementation. No shortcuts, no mocks, real testing only.