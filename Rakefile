# frozen_string_literal: true

require 'bridgetown'

Bridgetown.load_tasks

# Run rake without specifying any command to execute a deploy build by default.
task default: :deploy

#
# Standard set of tasks, which you can customize if you wish:
#
desc 'Build the Bridgetown site for deployment'
task deploy: [:clean, 'frontend:build'] do
  Bridgetown::Commands::Build.start
end

desc 'Build the site in a test environment'
task :test do
  ENV['BRIDGETOWN_ENV'] = 'test'
  Bridgetown::Commands::Build.start
end

desc 'Runs the clean command'
task :clean do
  Bridgetown::Commands::Clean.start
end

namespace :frontend do
  desc 'Build the frontend (esbuild for JS, Tailwind CLI for CSS) for deployment'
  task :build do
    # esbuild first so the frontend manifest exists, then Tailwind compiles and
    # fingerprints its CSS into that manifest.
    sh 'yarn run esbuild'
    sh 'bin/tailwindcss'
  end

  desc 'Watch the frontend (esbuild for JS, Tailwind CLI for CSS) during development'
  task :dev do
    # Run Tailwind's watcher alongside esbuild so both rebuild on change.
    Bridgetown::Utils::Aux.run_process('Tailwind', :magenta, 'bin/tailwindcss --watch')
    sh 'yarn run esbuild-dev'
  rescue Interrupt
  end
end

desc 'Runs the update commands'
task update: ['update:cssdb', 'update:yarn']

namespace :update do
  desc 'Update browserslist db'
  task :cssdb do
    sh 'npx update-browserslist-db@latest'
  end

  desc 'Update yarn dependencies'
  task :yarn do
    sh 'yarn upgrade-interactive --latest && yarn upgrade'
  rescue Interrupt
  end
end

#
# Add your own Rake tasks here! You can use `environment` as a prerequisite
# in order to write automations or other commands requiring a loaded site.
#
# task :my_task => :environment do
#   puts site.root_dir
#   automation do
#     say_status :rake, "I'm a Rake tast =) #{site.config.url}"
#   end
# end
