// vite.config.ts
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
      // Mọi request bắt đầu bằng /api sẽ được forward sang API server
      "/api": {
        target: "http://localhost:4000",
        changeOrigin: true,
        // tùy chọn: nếu backend không có prefix /api thì bật rewrite:
        // rewrite: (path) => path.replace(/^\/api/, ""),
      },
    },
  },
});
