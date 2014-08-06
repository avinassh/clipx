require 'test_helper'
require 'loofah'

class EvernoteScrubberTest < ActiveSupport::TestCase
  def setup
    @scrubber = EvernoteScrubber.new
    @content = articles(:one).content
  end

  test 'should remove disallowed tags completely' do

    assert_equal "", self.scrub('<applet><div>Hello</div></applet>')
  end

  test 'should strip invalid tags' do
    assert_equal "<div>Hello</div>", self.scrub('<article><div>Hello</div></article>')
  end

  test 'should remove invalid attributes' do
    assert_equal '<div>Hello</div>', self.scrub('<div id="1">Hello</div>')
  end

  test 'should remove id attribute from an a tag' do
    assert_equal '<a href="http://clipx.captnemo.in/">Hello</a>', self.scrub('<a href="http://clipx.captnemo.in/" id="1">Hello</a>')
  end

  test 'should remove empty tags' do
    assert_equal "", self.scrub("<a></a>")
  end

  test 'should not remove empty void tags' do
    assert_equal "<br><img>", self.scrub("<br><img>")
  end

  test 'should not remove empty tags with any inner tags' do
    assert_equal "<div><img></div>", self.scrub("<div><img></div>")
  end

  test 'should work with namespaced attributes' do
    assert_equal '<div xml:lang="en">hello</div>', self.scrub('<div class:name="hello" xml:lang="en">hello</div>')
  end

  test 'should handle data-attributes' do
    assert_equal '<div>Hello</div>', self.scrub('<div data-name="hello">Hello</div>')
  end

  test 'should work with undefined tags' do
    assert_equal 'Hello', self.scrub('<undefined>Hello</undefined>')
  end

  def scrub(html)
    Loofah.fragment(html).scrub!(@scrubber).to_s
  end
end