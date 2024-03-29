#ClipX

Webpage archival service with multiple ways to clip and archive web pages automatically. Irrespective of whether you love pocket, instapaper, browser bookmarks, or email; we will store all content you throw at us in multiple places such as Dropbox, our website, Evernote. A downloadable archive of all your content will always be available to you as well.

Never worry about another clipping service going down. We're here to save your content, forever. (And if we go down, you still retain a copy of all your content).

##List of Services

1. Fetch Articles from various sources
    - Runs using Resque
    - Optionally as a Rake task as well
2. Web Service
    - Show status of each article
    - Show logs of each fetch and push request
    - Link status to each account
    - Also create/edit/view article
3. Database
    - Users (EMail, Name (and more))
    - Article (URL, Title, Content, Status, Provider)
        + Belongs to User
    - Various Integration Accounts
        + Belongs to User
4. Extractor Service
    - Fetches an article content
5. Publisher Service
    - Publishes an article to any source

##Options
1. Make as separate services talking to each other via the database or some job agent
2. Make the entire thing as a giant rails app
    - Cron jobs will be converted to queues in rails
    - Can't deploy on free heroku any more (single dyno)
    - Should be a good learning experience

##Things to think about
- OAuth implementations
- User accounts (Make pocket primary account, I think)
- Copy over tags from pocket to evernote
- Don't involve ifttt
- Make sure readability is fine with it
    + Shift to some other API if needed
- Make it modular (later?)
    + Alternative to both pocket and evernote
    + Bookmark to evernote
    + Instapaper to evernote
    + Pocket to Pinboard

##URL Endpoints
-  / Home Page with description of service

##Triggers
- Bookmarks (add a bookmark to a directory)
    + Later, we can give an option to save *all bookmarks*, not just those in the directory
- Pocket (add a new URL)
- Instapaper (add a new URL)
- EMail (send us an email)
- Readability (add a new URL)

##Publishers
- Evernote
- Dropbox
- Skydrive/Box
- Our website (we store a copy of all links and their content)
- Pinboard

##Filters
Filters are optional elements that control the trigger of each service. For eg, you may only want to archive the `#clipx` tag on pocket.

##Search
All articles are indexed and saved in elasticsearch, most probably. A user can search through all of *his* content easily. All content is tagged as well.

##Images & Media
Currently, we just archive html text, and don't worry about images or videos or making them available offline.
