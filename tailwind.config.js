/** @type {import('tailwindcss').Config} */
module.exports = {
  mode: 'jit',
  content: [
    "./src/**/*.{md,rb,erb,html}",
    "./frontend/javascript/**/*.js"
  ],
  theme: {
    extend: {
      fontFamily: {
        inter: [
          'Inter var',
          'Inter',
          'ui-sans-serif',
          'system-ui',
          '-apple-system',
          'BlinkMacSystemFont',
          '"Segoe UI"',
          'Roboto',
          '"Helvetica Neue"',
          'Arial',
          '"Noto Sans"',
          'sans-serif',
          '"Apple Color Emoji"',
          '"Segoe UI Emoji"',
          '"Segoe UI Symbol"',
          '"Noto Color Emoji"',
        ]
      },
      height: {
        '8': '2rem'
      },
      width: {
        '8': '2rem'
      }
    },

    borderWidth: {
      '12': '12px'
    }
  },
  plugins: [],
}
