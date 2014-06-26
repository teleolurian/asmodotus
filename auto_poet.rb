require 'cgi'
require 'open-uri'
require 'json'

class AutoPoet
  BaseURL = 'http://suggestqueries.google.com/complete/search?client=chrome&q='
  Seeds = ['i love', 'you are', 'why does', 'why do', 'why not', 'i have', 'why are', 'where is', 'when will',
    'who is', 'will i', 'can i', 'my girlfriend', 'my boyfriend', "i can't", 'i can', 'my dad', 'my mom', 'my wife',
    'my husband', 'our family', 'some people', 'why do boys', 'why do girls'
    ]
  KillWords = ['lyrics', 'http']
  attr_reader :text, :matches
  def initialize(seed_text = nil)
    seed_text ||= AutoPoet::Seeds.shuffle.pop
    @seeds = [@text = seed_text]
    @matches = []
    @max_repetitions = 7
  end

  def request
    @terms = self.filter(JSON.parse(open(AutoPoet::BaseURL + CGI.escape(@seeds[-1])).read)[1])
  end

  def filter(terms = [])
    terms.select {|t| AutoPoet::KillWords.select {|kw| t[kw]}.empty? }
  end

  def acquire_seed(term)
    words = term.split(/\s+/)
    (words[-2..-1] || words).join(' ')
  end

  def chain(text)
    @matches << text
    len = text.length + 1
    until text.slice(0,len) == @text[-len,len] or len < 1
      len -= 1
    end
    @text += ' ' if len < 1
    @text += text[len..-1]
    text
  end

  def step
    @max_repetitions -= 1
    return unless @max_repetitions > 0
    self.request
    return if @terms.empty?
    index = @terms.length - 1
    chosen_term = nil
    probable_seed = nil
    @terms.shuffle!
    while index > 0 && !probable_seed
      chosen_term = @terms[@terms.length - index]
      probable_seed = acquire_seed(chosen_term)
      chosen_term = nil if @seeds.include?(probable_seed)
      index -= 1
    end
    return unless chosen_term and probable_seed
    @seeds << probable_seed
    chain(chosen_term)
  end

  class << self
    def spew
      poet = self.new
      :D while poet.step
      poet.text
    end

    def chain(text = nil, &blk)
      poet = self.new(text)
      while match = poet.step
        blk.call(match) if block_given?
      end
      poet.matches
    end
  end
end



AutoPoet.chain {|x| puts x}  if __FILE__ == $0
