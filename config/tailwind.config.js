const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
 safelist: [
    {
      pattern: /(bg|border)-(red|purple|pink|indigo|slate|amber|emerald|cyan)-(50|400|500)/,
    },
    {
      pattern: /md:hover:border-(red|purple|pink|indigo|slate|amber|emerald|cyan)-500/,
    }
  ],
  plugins: [
    // require('@tailwindcss/forms'),
    // require('@tailwindcss/typography'),
    // require('@tailwindcss/container-queries'),
  ]
}
