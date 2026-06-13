/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{html,ts}",
  ],
  theme: {
    extend: {
      fontFamily: {
        japanese: ['"Klee One"', 'serif'],
      }
    },
  },
  plugins: [],
}
