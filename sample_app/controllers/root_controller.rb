class RootController < ApplicationController
  get('/') do
    render(:erb, :index)
  end
end
