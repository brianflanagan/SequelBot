require 'wordnet'

class String
  def uncapitalize
    self[0, 1].downcase + self[1..-1]
  end

  def capitalize
    self[0, 1].upcase + self[1..-1]
  end

  def is_noun?
    lemma = WordNet::Lemma.find(self.downcase, :noun)
    return lemma
  end
end