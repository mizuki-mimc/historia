module StoriesHelper
  def genre_color_name(genre)
    case genre
    when "fantasy"
      "red"
    when "sf"
      "purple"
    when "romance"
      "pink"
    when "mystery"
      "indigo"
    when "horror"
      "slate"
    when "history"
      "amber"
    when "contemporary"
      "emerald"
    else
      "cyan"
    end
  end
end
