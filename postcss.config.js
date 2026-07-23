// Tailwind CSS v4 no longer runs through PostCSS — it is compiled by the
// Tailwind CLI (see `bin/tailwindcss`). This config is intentionally minimal;
// Bridgetown's esbuild integration still loads it, but no PostCSS plugins are
// needed now that esbuild bundles JavaScript only.
export default {
  plugins: {}
}
