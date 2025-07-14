#!/bin/bash

# React Native Conversion Execution Script for Claude Code UI
# This script automates the React Native project setup and initial implementation

set -e  # Exit on error

echo "🚀 Starting React Native Conversion for Claude Code UI"
echo "=================================================="

# Check if we're in the right directory
if [ ! -f "package.json" ] || [ ! -d "server" ]; then
    echo "❌ Error: This script must be run from the claudecodeui root directory"
    exit 1
fi

# Function to check command existence
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo "📋 Checking prerequisites..."
for cmd in node npm npx pod; do
    if ! command_exists $cmd; then
        echo "❌ Error: $cmd is not installed"
        exit 1
    fi
done
echo "✅ All prerequisites met"

# Create mobile directory
echo -e "\n📁 Creating mobile app directory..."
mkdir -p mobile

# Initialize React Native project
echo -e "\n🎯 Task 1: Initializing React Native project with TypeScript..."
cd mobile
npx react-native@latest init ClaudeCodeMobile --template react-native-template-typescript --skip-install

cd ClaudeCodeMobile

# Install core dependencies
echo -e "\n📦 Task 2: Installing core navigation dependencies..."
npm install @react-navigation/native @react-navigation/native-stack

echo -e "\n📦 Task 3: Installing iOS-specific and other core dependencies..."
npm install react-native-screens react-native-safe-area-context
npm install react-native-keychain
npm install react-native-vector-icons
npm install react-native-paper
npm install react-native-device-info

# iOS setup
echo -e "\n🍎 Running pod install for iOS..."
cd ios
pod install
cd ..

# Create project structure
echo -e "\n🏗️ Task 4: Setting up project structure..."
mkdir -p src/{components/{auth,chat,projects,settings,common},navigation,services/{api,websocket,storage},utils,types}

# Create secure storage service
echo -e "\n🔐 Task 5: Creating secure storage service..."
cat > src/services/storage/secureStorage.ts << 'EOF'
import * as Keychain from 'react-native-keychain';

export interface StoredCredentials {
  token: string;
  refreshToken?: string;
}

export interface BackendConfig {
  url: string;
  wsUrl: string;
}

export const SecureStorage = {
  // JWT Token Management
  async setToken(token: string, refreshToken?: string): Promise<void> {
    await Keychain.setInternetCredentials(
      'claudecode-auth',
      'jwt-token',
      JSON.stringify({ token, refreshToken })
    );
  },

  async getToken(): Promise<StoredCredentials | null> {
    try {
      const credentials = await Keychain.getInternetCredentials('claudecode-auth');
      if (credentials) {
        return JSON.parse(credentials.password);
      }
      return null;
    } catch (error) {
      console.error('Error retrieving token:', error);
      return null;
    }
  },

  async clearToken(): Promise<void> {
    await Keychain.resetInternetCredentials('claudecode-auth');
  },

  // Backend Configuration
  async setBackendConfig(config: BackendConfig): Promise<void> {
    await Keychain.setInternetCredentials(
      'claudecode-config',
      'backend-url',
      JSON.stringify(config)
    );
  },

  async getBackendConfig(): Promise<BackendConfig | null> {
    try {
      const credentials = await Keychain.getInternetCredentials('claudecode-config');
      if (credentials) {
        return JSON.parse(credentials.password);
      }
      return null;
    } catch (error) {
      console.error('Error retrieving backend config:', error);
      return null;
    }
  },

  // Biometric Support Check
  async getBiometryType(): Promise<Keychain.BIOMETRY_TYPE | null> {
    return await Keychain.getSupportedBiometryType();
  },
};
EOF

# Create WebSocket manager
echo -e "\n🔌 Task 8: Creating WebSocket manager..."
cat > src/services/websocket/WebSocketManager.ts << 'EOF'
export class WebSocketManager {
  private ws: WebSocket | null = null;
  private url: string;
  private token: string;
  private reconnectAttempts = 0;
  private maxReconnectAttempts = 5;
  private reconnectDelay = 1000;
  private messageHandlers: Map<string, (data: any) => void> = new Map();

  constructor(url: string, token: string) {
    this.url = url;
    this.token = token;
  }

  connect(): Promise<void> {
    return new Promise((resolve, reject) => {
      try {
        this.ws = new WebSocket(`${this.url}?token=${this.token}`);

        this.ws.onopen = () => {
          console.log('WebSocket connected');
          this.reconnectAttempts = 0;
          resolve();
        };

        this.ws.onmessage = (event) => {
          try {
            const message = JSON.parse(event.data);
            this.handleMessage(message);
          } catch (error) {
            console.error('Error parsing WebSocket message:', error);
          }
        };

        this.ws.onerror = (error) => {
          console.error('WebSocket error:', error);
          reject(error);
        };

        this.ws.onclose = () => {
          console.log('WebSocket disconnected');
          this.handleReconnect();
        };
      } catch (error) {
        reject(error);
      }
    });
  }

  private handleMessage(message: any) {
    const { type, data } = message;
    const handler = this.messageHandlers.get(type);
    if (handler) {
      handler(data);
    }
  }

  private handleReconnect() {
    if (this.reconnectAttempts < this.maxReconnectAttempts) {
      const delay = this.reconnectDelay * Math.pow(2, this.reconnectAttempts);
      console.log(`Reconnecting in ${delay}ms...`);
      
      setTimeout(() => {
        this.reconnectAttempts++;
        this.connect().catch(console.error);
      }, delay);
    }
  }

  onMessage(type: string, handler: (data: any) => void) {
    this.messageHandlers.set(type, handler);
  }

  send(type: string, data: any) {
    if (this.ws && this.ws.readyState === WebSocket.OPEN) {
      this.ws.send(JSON.stringify({ type, data }));
    } else {
      console.error('WebSocket is not connected');
    }
  }

  disconnect() {
    if (this.ws) {
      this.ws.close();
      this.ws = null;
    }
  }
}
EOF

# Create API client
echo -e "\n🌐 Creating API client..."
cat > src/services/api/apiClient.ts << 'EOF'
import { SecureStorage } from '../storage/secureStorage';

export class ApiClient {
  private baseUrl: string;

  constructor(baseUrl: string) {
    this.baseUrl = baseUrl;
  }

  private async getHeaders(): Promise<HeadersInit> {
    const credentials = await SecureStorage.getToken();
    const headers: HeadersInit = {
      'Content-Type': 'application/json',
    };

    if (credentials?.token) {
      headers['Authorization'] = `Bearer ${credentials.token}`;
    }

    return headers;
  }

  async get<T>(endpoint: string): Promise<T> {
    const headers = await this.getHeaders();
    const response = await fetch(`${this.baseUrl}${endpoint}`, {
      method: 'GET',
      headers,
    });

    if (!response.ok) {
      throw new Error(`API Error: ${response.statusText}`);
    }

    return response.json();
  }

  async post<T>(endpoint: string, data?: any): Promise<T> {
    const headers = await this.getHeaders();
    const response = await fetch(`${this.baseUrl}${endpoint}`, {
      method: 'POST',
      headers,
      body: data ? JSON.stringify(data) : undefined,
    });

    if (!response.ok) {
      throw new Error(`API Error: ${response.statusText}`);
    }

    return response.json();
  }

  async put<T>(endpoint: string, data?: any): Promise<T> {
    const headers = await this.getHeaders();
    const response = await fetch(`${this.baseUrl}${endpoint}`, {
      method: 'PUT',
      headers,
      body: data ? JSON.stringify(data) : undefined,
    });

    if (!response.ok) {
      throw new Error(`API Error: ${response.statusText}`);
    }

    return response.json();
  }

  async delete<T>(endpoint: string): Promise<T> {
    const headers = await this.getHeaders();
    const response = await fetch(`${this.baseUrl}${endpoint}`, {
      method: 'DELETE',
      headers,
    });

    if (!response.ok) {
      throw new Error(`API Error: ${response.statusText}`);
    }

    return response.json();
  }
}
EOF

# Update iOS configuration
echo -e "\n🍎 Task 17 & 18: Configuring iOS settings..."
cat > ios/ClaudeCodeMobile/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleDisplayName</key>
    <string>Claude Code</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
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
    <key>NSFaceIDUsageDescription</key>
    <string>Authenticate to access your Claude Code account</string>
    <key>UILaunchStoryboardName</key>
    <string>LaunchScreen</string>
    <key>UIRequiredDeviceCapabilities</key>
    <array>
        <string>arm64</string>
    </array>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
    </array>
    <key>UIViewControllerBasedStatusBarAppearance</key>
    <false/>
</dict>
</plist>
EOF

echo -e "\n✅ Initial React Native setup complete!"
echo "📍 Mobile app created at: mobile/ClaudeCodeMobile"
echo ""
echo "Next steps:"
echo "1. cd mobile/ClaudeCodeMobile"
echo "2. Start Metro: npx react-native start"
echo "3. Run on iOS: npx react-native run-ios"
echo ""
echo "To continue implementation, run individual task scripts or develop components manually."