class ApplicationController < Sinatra::Base

  ########################
  # Configuration
  ########################
  set :app_file,  File.expand_path(File.dirname(__FILE__), '../')

  helpers ApplicationHelper
  # allow put/delete forms in browsers that don't support it.
  enable :method_override
  # store data between HTTP requests in a cookie
  enable :sessions
  # session_secret will change with every start of the application
  # if we want to run shotgun, which creates new application instances
  # we must manually set session_secret
  set :session_secret, 'super secret'

  configure :test, :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
  end

end
