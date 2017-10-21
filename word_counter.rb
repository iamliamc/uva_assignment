require 'nokogiri'
require 'open-uri'
require 'tokenizer'
require 'lemmatizer'
require 'histogram/array'
require 'chartkick'
include Chartkick::Helper

class WordCounter
  attr_accessor :source_url, :text_source, :lem, :preprocess_storage, :word_count, :articles_with_counts, :word_count_table

  def initialize
    @source_url = "http://gss.uva.nl/binaries/content/assets/programmas/information-studies/txt-for-assignment-data-science.txt?3015083536432"
    @text_source = "./txt-for-assignment-data-science.txt"
    @lem = Lemmatizer.new
    @preprocess_storage = {}
    @articles_with_counts = {}
    @word_count_table = {}
    retrieve_tokenize_and_lemmatize
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
    @preprocess_storage.each do |article_id, tokenized_article|
      @articles_with_counts[article_id + 1] = count(tokenized_article)
    end
  end

  def count_tokens_by_collection
    count(@preprocess_storage.values.flatten)
  end

  def article_counts_by_word
    @articles_with_counts.each do |article_id, counts_by_word|
      counts_by_word.each do |word, count|
        @word_count_table[word] ||= []
        @word_count_table[word].push([article_id, count])
      end
    end
  end

  def histogram_data_for_collection
    collection_counts = count_tokens_by_collection.values
    (bins, freq) = collection_counts.histogram(collection_counts.uniq.sort)
  end

  def format_for_plotting(histogram_arrays)
    frequency_count_hash = {}
    count_array = histogram_arrays[0]
    frequency_array = histogram_arrays[1]
    count_array.each_with_index do |count, index|
      frequency_count_hash[count.to_i] = frequency_array[index].to_i
    end
    frequency_count_hash
  end

  def plot_histogram
    @data = format_for_plotting(histogram_data_for_collection)
    template = "<%= column_chart @data, xtitle: 'Word Count', ytitle: 'Count Frequency' %>"
    renderer = ERB.new(template)
    graph_results = renderer.result()
    open('frequency_count_plot.html', 'w+') do |f|
      f.puts '<script src="https://www.google.com/jsapi"></script>'
      f.puts '<script src="chartkick.js"></script>'
      f.puts graph_results
    end
  end

  def count_source
    count_tokens_by_article
    article_counts_by_word
    @word_count_table
  end
end

# ruby doesn't have a native implementation of linked lists
class Node
  attr_accessor :value, :next_node, :previous_node

  def initialize(value, next_node, previous_node)
    @value = value
    @next_node = next_node
    @previous_node  = previous_node
  end
end
