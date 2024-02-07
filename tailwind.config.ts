import { Config } from 'tailwindcss';
import daisyui from 'daisyui';

const config: Config = {
  content: ['./src/**/*.{js,ts,jsx,tsx,mdx}'],
  theme: {
    extend: {
      screens: {
        '2xlm': {'max': '1536px'},
        '3xl': '2400px',
        '4xl': '3400px',
      },
    },
  },
  plugins: [daisyui],
};

export default config;