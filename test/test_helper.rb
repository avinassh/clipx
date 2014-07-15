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
      }
    })
  end
end
