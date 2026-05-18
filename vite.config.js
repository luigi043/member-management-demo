import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// Vite + Vitest configuration.
// `test` block configures the unit-test runner (Vitest) so `npm test` works
// out of the box with a jsdom DOM environment for React component tests.
export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: './tests/setup.js',
    include: ['tests/**/*.test.{js,jsx}'],
    coverage: {
      reporter: ['text', 'lcov'],
    },
  },
});
