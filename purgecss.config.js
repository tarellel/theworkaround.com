module.exports = {
  content: ['frontend/javascript/*.js','./output/**/*.html'],
  // https://stackoverflow.com/questions/65554596/purgecss-and-tailwind-css-how-to-preserve-responsive-classes-using-the-command
  // defaultExtractor: (content) => content.match(/[\w-/:]+(?<!:)/g) || [],
  defaultExtractor: (content) => content.match(/[\w-/:.]+(?<!:)/g) || [],
  output: "./output/_bridgetown/static"
}
