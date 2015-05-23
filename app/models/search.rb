class Search
  SEARCH_OPTIONS = %i(everywhere questions answers comments users)

  def self.filter(query, options = {})
    condition = options[:condition].to_sym
    safe_query = Riddle::Query.escape(query)

    case condition
    when SEARCH_OPTIONS[1]
      Question.search safe_query
    when SEARCH_OPTIONS[2]
      Answer.search safe_query
    when SEARCH_OPTIONS[3]
      Comment.search safe_query
    when SEARCH_OPTIONS[4]
      User.search safe_query
    else
      ThinkingSphinx.search safe_query
    end
  end
end
