class GooglePublisher < PublisherService
  def publish (account, article)
    client = GoogleUtil.new account
    client.add_row account.spreadsheet_id, self.article_to_row(article)
  end

  def export (account)
    # First, lets create a 2d array of what to insert
    table = Array.new
    table.push ["Title", "Tags", "Created At", "Provider"]
    # Ready the client as well
    client = GoogleUtil.new account

    account.user.articles.find_each do |article|
      # We take all of these and export/write it to a spreadsheet
      table.push self.article_to_row(article)
    end

    # Now we write the table to actual spreadsheet
    client.add_table table
  end

  def article_to_row(article)
    ["=HYPERLINK(\"#{article.url}\", \"#{article.title_or_heading}\")", article.tags, article.created_at, article.provider]
  end
end