module UsersHelper
  def are_there_any_posts?
    @user.posts.size > 0
  end
  def are_there_any_comments?
    @user.comments.size > 0
  end
  def are_there_any_favorites?
    @user.favorites.size > 0
  end
end
