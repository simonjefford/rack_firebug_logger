# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_test_rails_app_session',
  :secret      => '592efd6acbcd615ee01105adaefdda3c56eb6db048a398ba2a734407e15a797214535512f06b250d24fc4bdfa2f2b7f6a310a00cfbce2eadb45a285c3a4520b2'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
