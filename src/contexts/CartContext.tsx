import React, { createContext, useContext, useReducer, ReactNode } from 'react';
import { Product, ProductVariant } from '../api'; // ⬅️ đổi nguồn import

// CartItem kế thừa Product để giữ UI cũ hoạt động
interface CartItem extends Product {
  quantity: number;
  selectedColor: string;
  selectedSize: string;
  variantId?: number;
  sku?: string | null;
  unitPrice: number; // giá thực tính tiền (ưu tiên giá variant)
}

interface CartState {
  items: CartItem[];
  total: number;
  itemCount: number;
}

type CartAction =
  | { type: 'ADD_ITEM'; payload: { product: Product; color: string; size: string; quantity: number; variant?: ProductVariant } }
  | { type: 'REMOVE_ITEM'; payload: string }
  | { type: 'UPDATE_QUANTITY'; payload: { id: string; quantity: number } }
  | { type: 'CLEAR_CART' };

const initialState: CartState = {
  items: [],
  total: 0,
  itemCount: 0
};

function recalc(items: CartItem[]) {
  const total = items.reduce((sum, item) => sum + item.unitPrice * item.quantity, 0);
  const itemCount = items.reduce((count, item) => count + item.quantity, 0);
  return { total, itemCount };
}

function cartReducer(state: CartState, action: CartAction): CartState {
  switch (action.type) {
    case 'ADD_ITEM': {
      const { product, color, size, quantity, variant } = action.payload;

      // khoá tính tiền: ưu tiên giá của variant nếu có
      const unitPrice = (variant?.price ?? product.price) as number;
      const variantId = variant?.id;
      const sku = variant?.sku ?? null;

      const keyMatches = (item: CartItem) =>
        item.id === product.id && item.selectedColor === color && item.selectedSize === size;

      const existingIndex = state.items.findIndex(keyMatches);
      let newItems: CartItem[];

      if (existingIndex >= 0) {
        const updated = [...state.items];
        const target = updated[existingIndex];

        // nếu lần đầu thêm có variant, nhớ cập nhật variant info
        updated[existingIndex] = {
          ...target,
          quantity: target.quantity + quantity,
          unitPrice, // cập nhật giá nếu variant có giá khác
          variantId: variantId ?? target.variantId,
          sku: sku ?? target.sku,
        };
        newItems = updated;
      } else {
        const newItem: CartItem = {
          ...product,
          quantity,
          selectedColor: color,
          selectedSize: size,
          variantId,
          sku,
          unitPrice,
        };
        newItems = [...state.items, newItem];
      }

      const { total, itemCount } = recalc(newItems);
      return { items: newItems, total, itemCount };
    }

    case 'REMOVE_ITEM': {
      const newItems = state.items.filter(item =>
        `${item.id}-${item.selectedColor}-${item.selectedSize}` !== action.payload
      );
      const { total, itemCount } = recalc(newItems);
      return { items: newItems, total, itemCount };
    }

    case 'UPDATE_QUANTITY': {
      const newItems = state.items
        .map(item =>
          `${item.id}-${item.selectedColor}-${item.selectedSize}` === action.payload.id
            ? { ...item, quantity: action.payload.quantity }
            : item
        )
        .filter(item => item.quantity > 0);

      const { total, itemCount } = recalc(newItems);
      return { items: newItems, total, itemCount };
    }

    case 'CLEAR_CART':
      return initialState;

    default:
      return state;
  }
}

interface CartContextType extends CartState {
  addItem: (product: Product, color: string, size: string, quantity: number, variant?: ProductVariant) => void;
  removeItem: (id: string, color: string, size: string) => void;
  updateQuantity: (id: string, color: string, size: string, quantity: number) => void;
  clearCart: () => void;
}

const CartContext = createContext<CartContextType | undefined>(undefined);

export const useCart = () => {
  const context = useContext(CartContext);
  if (!context) throw new Error('useCart must be used within a CartProvider');
  return context;
};

interface CartProviderProps {
  children: ReactNode;
}

export const CartProvider: React.FC<CartProviderProps> = ({ children }) => {
  const [state, dispatch] = useReducer(cartReducer, initialState);

  // thêm vào giỏ: truyền variant nếu người dùng đã chọn màu/size từ trang ProductDetail
  const addItem = (product: Product, color: string, size: string, quantity: number, variant?: ProductVariant) => {
    dispatch({ type: 'ADD_ITEM', payload: { product, color, size, quantity, variant } });
  };

  const removeItem = (id: string, color: string, size: string) => {
    dispatch({ type: 'REMOVE_ITEM', payload: `${id}-${color}-${size}` });
  };

  const updateQuantity = (id: string, color: string, size: string, quantity: number) => {
    dispatch({ type: 'UPDATE_QUANTITY', payload: { id: `${id}-${color}-${size}`, quantity } });
  };

  const clearCart = () => dispatch({ type: 'CLEAR_CART' });

  const value: CartContextType = { ...state, addItem, removeItem, updateQuantity, clearCart };

  return <CartContext.Provider value={value}>{children}</CartContext.Provider>;
};
