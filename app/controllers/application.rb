# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_bddoc_session_id'
  before_filter :set_charset, :except => ["documentos"]
  
  def set_charset
    
    if request.xhr?
      headers['Content-Type'] = 'text/javascript; charset=UTF-8'
      headers['cache-control'] = 'no-cache'
    else
      headers['Content-Type'] = 'text/html; charset=UTF-8'
      headers['cache-control'] = 'no-cache'
    end
  end
  
end
