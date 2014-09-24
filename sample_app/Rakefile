# A method to get the name of our project from the root directory
# Rakefiles are just ruby so we can write methods in here too!
def project_name
  # __dir__ Returns the canonicalized absolute path of the directory of the
  # file from which this method is called.
  # evivalent to File.dirname(File.realpath(__FILE__)).
  File.basename(__dir__)
end

namespace :bundler do
  task :setup do
    require 'rubygems'
    require 'bundler'
  end
end

# $ rake environment
# $ rake environment[test]
# $ rake environment[production]
task :environment, [:env] => 'bundler:setup' do |cmd, args|
  env = args[:env] || ENV["RACK_ENV"] || "development"
  Bundler.require(:default, env)
  require "./config/boot"
end

namespace :db do

  # ENV["RACK_ENV"] is set to production on heroku
  # to invoke the task in a specific environment
  # we can run the task in two ways:
  #   $ rake db:setup[test]
  #   $ rake db:setup RACK_ENV=test
  desc "creates db, applies migrations, seeds db"
  task :setup, [:env] do |cmd, args|
    env = args[:env] || ENV["RACK_ENV"] || "development"
    Rake::Task['db:create'].invoke(env)
    Rake::Task['db:migrate'].invoke(env)
    Rake::Task['db:seed'].invoke(env)
  end

  desc "Rollback the database"
  task :rollback, :env do |cmd, args|
    puts "reversing migration"
    env = args[:env] || ENV["RACK_ENV"] || "development"
    Rake::Task['environment'].invoke(env)
    require 'sequel/extensions/migration'
    version = (row = DB[:schema_info].first) ? row[:version] : nil
    Sequel::Migrator.apply(DB, "db/migrations", version - 1)
  end

  desc "creates a db"
  task :create, [:env] do |cmd, args|
    env = args[:env] || ENV["RACK_ENV"] || "development"
    sh("createdb #{project_name}_#{env}")
  end

  desc "drop db"
  task :drop, [:env] do |cmd, args|
    puts "Dropping db"
    env = args[:env] || ENV["RACK_ENV"] || "development"
    sh("dropdb #{project_name}_#{env}")
  end

  desc "Run database migrations"
  task :migrate, :env do |cmd, args|
    puts "Running migrations"
    env = args[:env] || ENV["RACK_ENV"] || "development"
    Rake::Task['environment'].invoke(env)
    require 'sequel/extensions/migration'
    # apply database, migration_folder
    # runs all migration files in db/migrations
    # generated first schema with
    # sequel postgres://localhost/dvr_app_development -d
    Sequel::Migrator.apply(DB, "db/migrations")
  end

  desc "seed db"
  # $ rake db:seed
  # $ rake db:seed[test]
  # $ rake db:seed[production]
  task :seed, [:env] do |cmd, args|
    # default environment
    puts "seeding db"
    env = args[:env] || ENV["RACK_ENV"] || "development"
    # load up my sinatra environment
    # then populate my database
    # calls rake environment[env]
    Rake::Task['environment'].invoke(env)
    require './db/seeds'
  end
end
