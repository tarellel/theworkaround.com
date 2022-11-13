module.exports = {
  content: ['frontend/javascript/*.js','./output/**/*.html'],
  // https://dev.to/andypeters/setup-bridgetown-to-use-tailwindcss-7nd
  // content: ["./src/**/*.html", "./src/**/*.md", "./src/**/*.liquid", "./frontend/**/*.js", "./src/_data/**/*.yml"],
  // https://stackoverflow.com/questions/65554596/purgecss-and-tailwind-css-how-to-preserve-responsive-classes-using-the-command
  // defaultExtractor: (content) => content.match(/[\w-/:]+(?<!:)/g) || [],
  defaultExtractor: (content) => content.match(/[\w-/:.]+(?<!:)/g) || [],
  output: "./output/_bridgetown/static"
}
