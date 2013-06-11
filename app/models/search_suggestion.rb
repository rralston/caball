class SearchSuggestion < ActiveRecord::Base
  attr_accessible :popularity, :term
  
  def self.terms_for(prefix)
    Rails.cache.fetch(["search-terms", prefix]) do 
      suggestions = where("term like ?", "#{prefix}_%")
      suggestions.order("popularity desc").limit(10).pluck(:term)
    end
  end
  
  def self.index_users
    User.find_each do |user|
      index_term(user.name)
      user.name.split.each { |t| index_term(t) }
    end
  end
  
  def self.index_term(term)
    where(term: term.downcase).first_or_create.tap do |suggestion|
      suggestion.increment! :popularity
    end
  end
end
