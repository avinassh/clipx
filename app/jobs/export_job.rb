class ExportJob
  # This job calls various publish services
  @queue = :export
  def self.perform(user_id, account_class_name)
    user = User.find(user_id)
    klass = account_class_name.constantize   # GoogleAccount
    obj_name = account_class_name.underscore # google_account
    account = user.send(obj_name.to_sym) # user.google_account
    publisher = account.publisher
    publisher.export account if publisher.respond_to?(:export) # user.google_account.publisher.export accoun
  end
end