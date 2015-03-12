module ApplicationHelper
  def options_for_ratings(selected=nil)
    options_for_select([5, 4, 3, 2, 1].map {|option| [pluralize(option, "Star"),
                        option]}, selected)
  end

  def can_be_followed?(user)
    !(current_user.friends.include?(user) || current_user == user)
  end
end
