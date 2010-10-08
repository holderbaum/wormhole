# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rails_session',
  :secret      => '68824572991fa79e8a9c3154a1c8a231f93c0ff111ac921b53c64ba9bacb50d20cb9d14ddf68d4700145a4e3a5bcb595de9499cf7f3ead8c7ddf4bdbbf376e75'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
