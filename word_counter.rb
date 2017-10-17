require 'nokogiri'
require 'open-uri'
require 'tokenizer'
require 'lemmatizer'
require_relative 'collection'

class WordCounter

  attr_accessor :source_url, :lem, :word_count_hash_table, :text_source, :preprocess_storage

  def initialize
    @source_url = "http://gss.uva.nl/binaries/content/assets/programmas/information-studies/txt-for-assignment-data-science.txt?3015083536432"
    @text_source = "./txt-for-assignment-data-science.txt"
    @lem = Lemmatizer.new
    @preprocess_storage = {}
    @word_count_hash_table = {}

    # simple white space tokenizer with ruby regex sufficient
    # @tokenizer = Tokenizer::WhitespaceTokenizer.new
  end

  def retrieve_tokenize_and_lemmatize
    doc = Nokogiri::HTML(open(@text_source))
    doc.search('text').each_with_index do |link, index|
      tokenized_text = link.content.scan(/\w+/)
      @preprocess_storage[index] = tokenized_text.map{ |token| @lem.lemma(token.downcase) }
    end
  end

  def work
    self.retrieve_tokenize_and_lemmatize
    self.preprocess_storage
  end
end
