# Memory Search Guide for React Native Implementation

## Overview
This document provides specific memory search queries and expected patterns for the React Native implementation of Claude Code UI. Use these exact search terms in mem0 to retrieve stored implementation patterns.

## Primary Memory Entries (Search These First)

### 1. Project Overview
**Search**: `React Native Claude Code UI Implementation`
**Contains**:
- Project details (claudecodeui, branch: feature/react-native)
- 25 implementation tasks list
- Key technical decisions
- Implementation approach

### 2. Secure Storage Pattern
**Search**: `React Native Secure Storage Implementation Pattern`
**Contains**:
- Complete react-native-keychain implementation
- JWT token storage methods
- Backend configuration storage
- Biometric authentication check

### 3. WebSocket Implementation
**Search**: `React Native WebSocket Manager Pattern`
**Contains**:
- Full WebSocketManager class
- Automatic reconnection logic
- Exponential backoff algorithm
- Message handler pattern

### 4. iOS Configuration
**Search**: `React Native iOS Configuration Requirements`
**Contains**:
- Complete Info.plist settings
- Network permissions (NSAppTransportSecurity)
- Biometric permissions (NSFaceIDUsageDescription)
- Xcode project settings

### 5. API Integration
**Search**: `Claude Code UI Backend API Integration Pattern`
**Contains**:
- ApiClient class with JWT headers
- All API endpoints list
- WebSocket event types
- Error handling patterns

## Secondary Searches (For Specific Features)

### Navigation Patterns
- `react-navigation-typescript-setup`
- `react-navigation-auth-flow`
- `navigation-conditional-rendering`

### Authentication
- `jwt-token-refresh-pattern`
- `biometric-authentication-ios`
- `keychain-credential-storage`

### UI Components
- `react-native-paper-forms`
- `keyboard-avoiding-view-pattern`
- `flatlist-optimization-techniques`

### Testing
- `react-native-device-testing`
- `ios-simulator-vs-device`
- `docker-backend-mobile-testing`

## How to Use This Guide

### For Each Task Implementation:

1. **Start with Primary Searches**
   ```
   Example for Task rn-5 (Secure Storage):
   - Search: "React Native Secure Storage Implementation Pattern"
   - This gives you the complete implementation code
   ```

2. **Use Secondary Searches for Details**
   ```
   Example for Task rn-7 (Authentication):
   - Search: "jwt-token-refresh-pattern"
   - Search: "biometric-authentication-ios"
   ```

3. **Store New Findings**
   ```
   After implementing a feature:
   - Store: "react-native-[feature]-implementation"
   - Include: Working code, pitfalls avoided, performance tips
   ```

## Expected Memory Content Structure

### Pattern Entries Include:
1. **Purpose**: What problem it solves
2. **Implementation**: Complete working code
3. **Key Points**: Important considerations
4. **Common Errors**: What to avoid

### Example Memory Entry Format:
```
Title: React Native [Feature] Implementation Pattern
Purpose: [What it does]
Implementation: [Full code block]
Key Points: [Bullet list of important notes]
Library Version: [react-native@0.73, etc]
Tested On: [iOS 17, iPhone 15 Pro]
```

## Creating New Memory Entries

When storing new patterns:

### Naming Convention:
- `React Native [Feature] [Specific Aspect]`
- Example: `React Native Chat Interface ScrollView Pattern`

### Must Include:
1. Library versions used
2. iOS version tested
3. Device tested on
4. Performance considerations
5. Error handling approach

### Cross-Project Value:
- Make entries generic enough for reuse
- Avoid project-specific details
- Focus on patterns, not implementations

## Troubleshooting Memory Searches

If a search returns no results:
1. Try broader terms: "React Native WebSocket" instead of specific class names
2. Search for the library name: "react-native-keychain"
3. Search for the problem: "secure storage iOS"

If patterns seem outdated:
1. Check library version in memory entry
2. Cross-reference with Context7 for latest docs
3. Update memory entry after confirming new approach

## Memory Maintenance

### Before Starting Implementation:
- Search all primary entries
- Note any missing patterns
- Plan Context7 queries for gaps

### During Implementation:
- Document working solutions immediately
- Note any deviations from stored patterns
- Record performance metrics

### After Implementation:
- Update existing entries with new findings
- Create new entries for novel solutions
- Tag with library versions and test devices

## Quick Reference Checklist

- [ ] Searched "React Native Claude Code UI Implementation"
- [ ] Found secure storage pattern
- [ ] Found WebSocket manager pattern
- [ ] Found iOS configuration requirements
- [ ] Found API integration pattern
- [ ] Identified gaps needing Context7 research
- [ ] Prepared to store new findings

Use this guide throughout the implementation to ensure consistent access to stored knowledge and proper documentation of new discoveries.