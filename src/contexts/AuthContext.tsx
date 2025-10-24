import React, { createContext, useContext, useState, ReactNode } from 'react';

interface User {
  id: string;
  name: string;
  email: string;
  role: 'customer' | 'admin';
  avatar?: string;
}

interface AuthState {
  user: User | null;
  isAuthenticated: boolean;
  isAdmin: boolean;
}

interface AuthContextType extends AuthState {
  login: (email: string, password: string) => Promise<boolean>;
  logout: () => void;
  register: (name: string, email: string, password: string) => Promise<boolean>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

// Mock users for demo
const mockUsers: User[] = [
  {
    id: '1',
    name: 'Admin User',
    email: 'admin@uniqlo.vn',
    role: 'admin'
  },
  {
    id: '2',
    name: 'Nguyễn Văn A',
    email: 'customer@email.com',
    role: 'customer'
  }
];

interface AuthProviderProps {
  children: ReactNode;
}

// Simple SHA-256 hashing using Web Crypto API. Fallback to a prefixed plain string when unavailable.
async function hashPassword(plain: string): Promise<string> {
  try {
    const encoder = new TextEncoder();
    const data = encoder.encode(plain);
    // @ts-ignore crypto in browser
    const digest = await (window.crypto || (globalThis as any).crypto).subtle.digest('SHA-256', data);
    const bytes = Array.from(new Uint8Array(digest));
    return bytes.map(b => b.toString(16).padStart(2, '0')).join('');
  } catch {
    // Fallback (not secure, but avoids storing raw password quietly)
    return `plain:${plain}`;
  }
}

async function ensureDefaultPasswordStore(): Promise<Record<string, string>> {
  const key = 'auth_password_store_v1';
  const raw = localStorage.getItem(key);
  let store: Record<string, string> = raw ? JSON.parse(raw) : {};

  // Seed default demo passwords only if missing
  if (!store['admin@uniqlo.vn']) {
    store['admin@uniqlo.vn'] = await hashPassword('admin123');
  }
  if (!store['customer@email.com']) {
    store['customer@email.com'] = await hashPassword('customer123');
  }

  localStorage.setItem(key, JSON.stringify(store));
  return store;
}

function readPasswordStore(): Record<string, string> {
  const key = 'auth_password_store_v1';
  const raw = localStorage.getItem(key);
  return raw ? JSON.parse(raw) : {};
}

function writePasswordStore(store: Record<string, string>) {
  const key = 'auth_password_store_v1';
  localStorage.setItem(key, JSON.stringify(store));
}

export const AuthProvider: React.FC<AuthProviderProps> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);

  const login = async (email: string, password: string): Promise<boolean> => {
    const foundUser = mockUsers.find(u => u.email === email);
    if (!foundUser) return false;

    // Ensure store and verify per-user password
    await ensureDefaultPasswordStore();
    const store = readPasswordStore();
    const submittedHash = await hashPassword(password);
    const expectedHash = store[email];
    if (expectedHash && submittedHash === expectedHash) {
      setUser(foundUser);
      return true;
    }
    return false;
  };

  const logout = () => {
    setUser(null);
  };

  const register = async (name: string, email: string, password: string): Promise<boolean> => {
    // Store hashed password in localStorage for demo purposes only
    await ensureDefaultPasswordStore();
    const store = readPasswordStore();
    const hashed = await hashPassword(password);
    store[email] = hashed;
    writePasswordStore(store);

    const newUser: User = {
      id: Date.now().toString(),
      name,
      email,
      role: 'customer'
    };
    setUser(newUser);
    return true;
  };

  const value: AuthContextType = {
    user,
    isAuthenticated: !!user,
    isAdmin: user?.role === 'admin',
    login,
    logout,
    register
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};