# Be sure to restart your server when you modify this file.

BomFetcher::Application.config.session_store :cookie_store, key: '_BomFetcher_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# BomFetcher::Application.config.session_store :active_record_store

ActionController::Base.expire_page '/stations'
ActionController::Base.expire_page '/stations.json'