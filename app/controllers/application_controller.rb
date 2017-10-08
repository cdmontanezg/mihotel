class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }

  def index
  end

  def daypilot
  end

end
