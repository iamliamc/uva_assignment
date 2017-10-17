require 'nokogiri'
require 'open-uri'
require 'tokenizer'
require 'lemmatizer'
require_relative 'collection'

class WordCounter

  attr_accessor :source_url, :text_source, :lem, :preprocess_storage, :word_count

  def initialize
    @source_url = "http://gss.uva.nl/binaries/content/assets/programmas/information-studies/txt-for-assignment-data-science.txt?3015083536432"
    @text_source = "./txt-for-assignment-data-science.txt"
    @lem = Lemmatizer.new
    @preprocess_storage = {}
    @word_count = {}
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

  def count(article_tokens)
    article_tokens.each_with_object({}) do |token, article_word_count|
      article_word_count[token] ||= 0
      article_word_count[token] += 1
    end
  end

  def count_tokens_by_article
    articles_with_count = {}
    @preprocess_storage.each do |article_id, tokenized_article|
      articles_with_count[article_id + 1] = count(tokenized_article)
    end
    articles_with_count
  end

  def work
    retrieve_tokenize_and_lemmatize
    count_tokens_by_article
  end
end
