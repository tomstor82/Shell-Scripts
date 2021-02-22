
// C/C++ Compiling

g++ <filename> -o <output filename>

// SCSS (Sass) Compiling

node-sass <filename.scss> <output filename.css>

// JSX Compiling

/* Install babel and react presets in local folder */

npx install --save-dev @babel/core @babel/cli @babel/preset-react

/* Compile */

npx babel --presets @babel/preset-react <filename.jsx> -o <output filename.js>

