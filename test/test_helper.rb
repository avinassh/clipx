require 'simplecov'
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
SimpleCov.start 'rails'
require 'ostruct'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def omniauth
    evernote = evernote_accounts(:default)
    
    DeepStruct.new({
      pocket: {
        credentials: {
          token:"Invalid Token"
        },
        uid:"sm"
      },
      evernote: {
        credentials:{
          token: evernote.token
        },
        info: {
          nickname: 'cantn3m0'
        },
        extra: {
          access_token: {
            params: {
              "edam_noteStoreUrl" => evernote.notestore_url
            }
          }
        }
      },
      twitter: {
        uid: "21758503",
        info: {
          nickname: "sm"
        },
        credentials: {
          token: "21758502-YRnKh42Jim9XQVhIfphhKkA6lH84COdn0dmwAGFmK",
          secret: "uMsCvtKb0HNf9tYkOS0rRC6UhTLj8mBW5sn7aX9Ah5IsY"
        }
      }
    })
  end
end
