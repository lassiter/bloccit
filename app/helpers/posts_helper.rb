module PostsHelper
  def user_is_authorized_for_post?(post)
       current_user && (current_user == post.user || current_user.admin? || current_user.moderator?)
  end
  def user_is_authorized_for_post_delete?(post)
       current_user && (current_user == post.user || current_user.admin?)
  end
end
