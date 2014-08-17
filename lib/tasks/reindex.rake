task :reindex => [:environment] do
  Article.extracted.reindex
  puts "All articles with content were reindexed"
end