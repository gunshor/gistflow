module Notifiable
    
  def self.included(base)
    base.after_create :create_notifications
  end
  
  def link_to_post
    title = self.content[0..40]
    post = self.class.name == "Comment" ? self.post : self
      
    controller = post.class.name.split('::').last.pluralize.downcase
    controller = "posts" if post.class.name = Post::Community
    
    link_to title, "#{controller}/#{self.id}"
  end
  
  def create_notifications
    Parser::Mention.new(self.content).user_ids.each do |user_id|
      Notification.create(
        :user_id => user_id,
        :notifiable_id => self.id,
        :notifiable_type => self.class.name
      )
    end
  end
end