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
      },
      github: {
        uid: 584254,
        info: {
          nickname: "sm",
        },
        credentials: {
          token: "0bf3c601fcd938f6f168e961affda4b9b953c322"
        }
      },
      google: {
        info: {
          email: "sm@clipx.in"
        },
        credentials: {
          token: "ya29.UQBoQPABwQjv-RwAAACvgw9NNIOijJ_ug1A3J8JyCmJKI209rEeoMJMJeUtVRQ",
          refresh_token: "1/e4KjLfXNx2_dlgcYkt2Ajd03cjJYRd6UBVzCP3DsvJo",
          expires_at: 1.hours.from_now.to_i
        }
      },
      dropbox: {
        uid: "1766114",
        info: {
          email: "sm@gmail.com"
        },
        credentials: {
          token: "dIADRzqNkRIAAAAAAAAIFUrCYPQJS2gd7hJgWG-Jt_66AJd1AmgEAJj4_T5iK1Oj"
        }
      }
    })
  end
end
