const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './app/components/**/*.{rb,erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Poppins', 'Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        gray: {
          light: '#f4f5f7',
          DEFAULT: '#727978',
          dark: '#1a2623'
        },
        red: {
          light: '#fde9eb',
          DEFAULT: '#e22235',
          dark: '#b91828'
        },
        purple: {
          light: '#ebe9ef',
          DEFAULT: '#47228e',
          dark: '#2d1b50'
        },
        green: {
          light: '#e6f3f2',
          DEFAULT: '#00918c',
          dark: '#015b57'
        },
        yellow: {
          light: '#fef3d7',
          DEFAULT: '#e89d0e',
          dark: '#b28206'
        },
        blue: {
          light: '#e1edfe',
          DEFAULT: '#106df9',
          dark: '#043c90'
        }
      }
    }
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}
