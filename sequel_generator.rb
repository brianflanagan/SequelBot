require './string'
require './bom'
require './imdb'
require './rotten_tomatoes'

CONJUNCTIONS = ['after', 'although', 'and', 'as', 'as far', 'as if', 'as long', 'as soon', 'as though', 'as well', 'because', 'before', 'both', 'but', 'either', 'even', 'if', 'even', 'though', 'for', 'how', 'however', 'if', 'if', 'only', 'in', 'case', 'in', 'order', 'that', 'neither', 'nor', 'now', 'once', 'only', 'or', 'provided', 'rather', 'than', 'since', 'so', 'so that', 'than', 'that', 'though', 'till', "'til", 'unless', 'until', 'when', 'whenever', 'where', 'whereas', 'wherever', 'whether', 'while', 'yet', '&']

PREPOSITIONS = ['of', 'in', 'to', 'for', 'with', 'on', 'at', 'from', 'by', 'about', 'as', 'into', 'like', 'through', 'after', 'over', 'between', 'out', 'against', 'during', 'without', 'before', 'under', 'around', 'among']

ARTICLES = ['the','a','an']

class SequelGenerator
  def self.generate_sequel
    loop do
      title = sequelize_components(componentize_film_title(random_film_title))
      return(title) if title
    end
  end

  private

  def self.random_film_title
    Imdb.random_film_title
  end

  def self.componentize_film_title(title)
    cleaned_title = clean_up_phrase(title)
    words = cleaned_title.split(' ')

    if (words.length == 2)
      return words
    else
      return attempt_to_get_two_phrases_from(cleaned_title)
    end
  rescue
    nil
  end

  def self.sequelize_components(components)
    return nil unless components && (components.length == 2)

    components.map { |c| '2 ' + c.strip.split(' ').map(&:capitalize).join(' ') }.join(' ')
  end

  def self.clean_up_phrase(phrase)
    phrase = remove_articles(phrase)
    phrase = phrase.gsub(/[\d_\W]+\Z/, '') # remove trailing numbers
    phrase = phrase.scan(/^[^\(]+/).first # ignore anything in parentheses
    phrase = phrase.scan(/^[^:]+/).first # ignore anything after a colon
    phrase.gsub!("'s",'')
    phrase.gsub!(".",'')
    phrase.strip.split(' ').map(&:uncapitalize).join(' ')
  rescue
    nil
  end

  def self.remove_articles(phrase)
    o_phrase = phrase
    ARTICLES.each do |badword|
      o_phrase.gsub!(/\b#{ badword }\b/i,'')
      o_phrase.gsub!('  ',' ')
    end

    o_phrase
  rescue
    nil
  end

  def self.attempt_to_get_two_phrases_from(title)
    return(nil) unless title
    components = nil

    CONJUNCTIONS.each do |conj|
      next unless title.include?(" #{ conj } ")
      some_components = title.split(" #{ conj } ")

      if (some_components.length == 2)
        components = some_components
        break
      end
    end

    return(components) if (components && components.length == 2)

    PREPOSITIONS.each do |prep|
      next unless title.include?(" #{ prep } ")
      some_components = title.split(" #{ prep } ")

      if (some_components.length == 2)
        components = some_components
        break
      end
    end

    return(components) if (components && components.length == 2)

  rescue
    nil
  end
end