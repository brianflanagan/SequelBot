require './string'
require './imdb'

CONJUNCTIONS = ['after', 'although', 'and', 'as', 'as far', 'as if', 'as long', 'as soon', 'as though', 'as well', 'because', 'before', 'both', 'but', 'either', 'even', 'if', 'even', 'though', 'for', 'how', 'however', 'if', 'if', 'only', 'in', 'case', 'in', 'order', 'that', 'neither', 'nor', 'now', 'once', 'only', 'or', 'provided', 'rather', 'than', 'since', 'so', 'so that', 'than', 'that', 'though', 'till', "'til", 'unless', 'until', 'when', 'whenever', 'where', 'whereas', 'wherever', 'whether', 'while', 'yet', '&']

PREPOSITIONS = ['of', 'in', 'to', 'for', 'with', 'on', 'at', 'from', 'by', 'about', 'as', 'into', 'like', 'through', 'after', 'over', 'between', 'out', 'against', 'during', 'without', 'before', 'under', 'around', 'among']

ARTICLES = ['the','a','an']

METHODS = [:fastfurious, :squeakquel, :thestreets, :theening]

class SequelGenerator
  def self.generate_sequel
    loop do
      title = sequelize_title(random_film_title)
      return(title) if title
    end
  end

  private

  def self.random_film_title
    Imdb.random_film_title
  end

  def self.sequelize_title(title)
    return if !title || !title.strip
    title = title.strip

    if has_numbers?(title)
      return add_one_to_numbers(title)
    end

    METHODS.size.times do
      i_title = title
      o_title = self.sequelize_title_with_method(i_title, METHODS.sample)
      return(o_title) if o_title
    end

    nil
  end

  def self.sequelize_title_with_method(title, method)
    case method
    when :fastfurious
      return fastfurious_title(title)
    when :squeakquel
      return squeakquel_title(title)
    when :thestreets
      return thestreets_title(title)
    when :theening
      return theening_title(title)
    end

    nil
  end

  # NUMBERS

  def self.has_numbers?(title) # TODO -- numbers in English too!
    return(false) unless title
    title.scan(/\d+/).any?
  end

  def self.add_one_to_numbers(title)
    title.scan(/\d+/).each do |number|
      title.gsub! number, (number.to_i + 1).to_s
    end

    title
  end

  # FASTFURIOUS: The Fast and the Furious = 2 Fast 2 Furious

  def self.fastfurious_title(title)
    return sequelize_components(componentize_film_title(title))
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
    phrase = phrase.scan(/^[^\(]+/).first # ignore anything in parentheses
    phrase = phrase.scan(/^[^:]+/).first # ignore anything after a colon
    phrase = phrase.gsub(/[\d_\W]+\Z/, '') # remove trailing numbers
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

  # SQUEAKQUEL: Alvin and the Chipmunks = Alvin and the Chipmunks 2: The Squeakquel

  def self.squeakquel_title(title)
    return(nil) unless title

    return "#{ title } 2: The Squeakquel"
  end

  # THESTREETS: Step Up = Step Up 2 The Streets

  def self.thestreets_title(title)
    return(nil) unless title

    return "#{ title } 2 the Streets"
  end

  # THEENING: Noun of the Noun: The Nounening

  def self.theening_title(title)
    return(nil) unless title

    last_word = title.split(' ').last

    return(nil) unless last_word.is_noun?

    # if it ends in y then replace the y with an i
    if last_word.scan(/(.+)y\z/i).any?
      last_word = "#{ last_word.scan(/(.+)y\z/i).first.first }i"
    # if it ends in a vowel then remove the vowel
    elsif last_word.scan(/[aeiou]\z/i).any?
      last_word = last_word.scan(/(.+)[aeiou]\z/i).first.first
    end

    return "#{ title } 2: The #{ last_word }ening"
  end
end