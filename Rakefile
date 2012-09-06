require 'rubygems'
require 'set'
require 'rake'

require_relative("lib/abbreviation")
require_relative("lib/bibliography")
require_relative("lib/parser")

def bibliography
  @bibliography ||= Bibliography.new
end

def load parser
  bibliography.load(parser)
end

def data *args
  File.expand_path(File.join('data', *args), File.dirname(__FILE__))
end

task :default => [:print]

desc "Print all loaded and parsed abbreviations in BibTeX format with long journal names"
task :long => [:load] do
  bibliography.abbreviations.each_pair do |symbol, abbreviations|
    puts abbreviations.to_long
  end
end

desc "Print all loaded and parsed abbreviations in BibTeX format with short journal names"
task :short => [:load] do
  bibliography.abbreviations.each_pair do |symbol, abbreviations|
    puts abbreviations.to_short
  end
end

desc "Print all loaded and parsed abbreviations in a TSV format"
task :tsv => [:load] do
  bibliography.abbreviations.each_pair do |symbol, abbreviations|
    puts abbreviations.to_tsv
  end
end

task :load => %w[caltech entrez life_sciences medicus meteorology sociology jabref jabref_long jabref_short].map { |source| "load:#{source}" }

namespace :load do 

  task :caltech => file(data("caltech.txt")) do
    load Parser.new(data("caltech.txt"), :split => "\t")
  end

  task :entrez => file(data("entrez.txt")) do
    load Parser.new(data("entrez.txt"), :strip => '"')
  end

  task :entrez => file(data("entrez.txt")) do
    load Parser.new(data("entrez.txt"), :strip => '"')
  end

  task :life_sciences => file(data("life_sciences.txt")) do
    load Parser.new(data("entrez.txt"), :strip => '')
  end

  task :medicus => file(data("medicus.txt")) do
    load Parser.new(data("medicus.txt"), :strip => ';')
  end

  task :meteorology => file(data("meteorology.txt")) do
    load Parser.new(data("meteorology.txt"), :strip => '"')
  end

  task :sociology => file(data("sociology.txt")) do
    load Parser.new(data("sociology.txt"), :strip => '"')
  end

  task :jabref => file(data("jabref.txt")) do
    load Parser::JabRef.new(data("jabref.txt"))
  end

  task :jabref_long => file(data("jabref_long.bib")) do
    load Parser::BibTeX.new(:long, data("jabref_long.bib"))
  end

  task :jabref_short => file(data("jabref_short.bib")) do
    load Parser::BibTeX.new(:short, data("jabref_short.bib"))
  end
  
end
