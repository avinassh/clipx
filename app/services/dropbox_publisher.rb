require 'render_anywhere'
require 'dropbox_sdk'
class DropboxPublisher < PublisherService
  include RenderAnywhere
  def publish(account, article)
    client = DropboxClient.new(account.token)

    # Get the path to save the article in
    year = article.created_at.time.strftime("%Y")
    month = article.created_at.time.strftime("%m")
    date = article.created_at.time.strftime("%d")
    # Replace all slashes with dashes to prevent extra directory creation
    filename = article.title_or_heading.gsub(/\/|\\/,'-')
    path = "/#{year}/#{month}/#{filename}.html"

    # Render the print view of the article
    set_instance_variable('article', article)
    html = render :template => 'articles/print', :layout => false

    # Save the article to dropbox
    # Third parameter is overwrite=true
    client.put_file(path, html, true)
  end
  def export(account)
    # First lets put the print css
    print_css = Rails.root.join('app', 'assets', 'stylesheets', 'print.css')
    DropboxClient.new(account.token).put_file("/assets/print.css", print_css, true)

    # and now we put the articles
    account.user.articles.find_each do |article|
      self.publish account, article
    end
  end
end