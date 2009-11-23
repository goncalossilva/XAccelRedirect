require 'x_accel_redirect'

# Add x_accel_redirect to ActionController
ActionController::Base.send(:include, XAccelRedirect::Controller)

