# React Native Implementation - Start Here

## Quick Start for Mac Implementation

You're about to implement the React Native version of Claude Code UI. This document tells you exactly what to do.

### 1. First Actions After Cloning

```bash
# You should be on the feature/react-native branch
git status  # Verify you're on feature/react-native

# Read these files in order:
cat docs/REACT_NATIVE_IMPLEMENTATION_GUIDE.md
cat docs/MEMORY_SEARCH_GUIDE.md
cat docs/REACT_NATIVE_IMPLEMENTATION_CONTEXT.md
cat docs/REACT_NATIVE_MAC_SETUP.md
```

### 2. Search Memory for Context

Search mem0 for these exact strings:
1. `React Native Claude Code UI Implementation`
2. `React Native Secure Storage Implementation Pattern`
3. `React Native WebSocket Manager Pattern`
4. `React Native iOS Configuration Requirements`
5. `Claude Code UI Backend API Integration Pattern`

### 3. Understanding the Task

You have 25 tasks (rn-1 through rn-25) to implement. They are:

**High Priority (Do First):**
- rn-1: Initialize React Native project
- rn-2: Install navigation dependencies
- rn-3: iOS dependencies and pod install
- rn-4: Set up project structure
- rn-5: Implement secure storage service
- rn-6: Create backend configuration screen
- rn-7: Implement authentication flow
- rn-8: Set up WebSocket manager
- rn-9: Create navigation structure
- rn-10: Migrate login screen UI

**Continue with remaining tasks in order...**

### 4. Key Technical Decisions Already Made

These decisions are final and stored in memory:
- Use `react-native-keychain` for secure storage (NOT AsyncStorage)
- Backend URL must be user-configurable (NOT hardcoded)
- WebSocket needs automatic reconnection with exponential backoff
- Test with real Docker backend (NO mocks)
- iOS 13.0 minimum deployment target

### 5. Implementation Approach for Each Task

For EVERY task:
1. Search mem0 for relevant patterns
2. Use Context7 for latest library docs
3. Implement with production standards
4. Test on real device AND simulator
5. Store new findings in mem0

### 6. Docker Backend Setup

The mobile app needs the backend running:
```bash
# Start backend
docker-compose -f docker-compose.dev.yml up -d

# Get your Mac's IP for mobile config
ifconfig | grep "inet " | grep -v 127.0.0.1
```

### 7. Critical Implementation Notes

**Backend Configuration (rn-6):**
- User enters URL like: `http://192.168.1.100:2008`
- Store in Keychain using pattern from memory
- Test connection before saving

**Security (rn-5, rn-7):**
- JWT tokens in Keychain only
- Biometric auth as user option
- No sensitive data in console logs

**WebSocket (rn-8):**
- Use exact pattern from memory
- Handle app backgrounding
- Queue messages when disconnected

### 8. What Success Looks Like

Each task is complete when:
- ✅ Runs on iOS simulator
- ✅ Runs on physical iPhone
- ✅ No TypeScript errors
- ✅ Connects to Docker backend
- ✅ Feature works end-to-end
- ✅ New patterns stored in mem0

### 9. Start Implementation Now

```bash
# Create the mobile directory and start
cd /path/to/claudecodeui
mkdir mobile
cd mobile

# Initialize React Native (Task rn-1)
npx react-native init ClaudeCodeMobile --template react-native-template-typescript
```

Then continue with task rn-2, rn-3, etc.

### 10. Remember

- This is PRODUCTION code - no shortcuts
- Test with REAL backend - no mocks
- Search memory BEFORE implementing
- Store findings AFTER implementing
- Physical device testing is REQUIRED

## Need Help?

The answers are in:
1. Memory (search the patterns listed above)
2. Context7 (for latest library docs)
3. The documentation files in /docs

Good luck with the implementation!