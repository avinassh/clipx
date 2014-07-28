require 'sanitize'
module ApplicationHelper
  def sanitize(html)
    Sanitize.fragment(html, Sanitize::Config::RELAXED)
  end
end
