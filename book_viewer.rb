require 'tilt/erubis'
require "sinatra"
require "sinatra/reloader"

before do 
  @contents = File.readlines("data/toc.txt")
  
end

not_found do 
  redirect "/"
end

helpers do 
  def in_paragraphs(str)
    str.split("\n\n").map { |paragraph| "<p>#{paragraph}</p>"}.join
  end

  def text_found_in_chapter?(chapter, text)
    chapter.match?(/#{text}/i)
  end
end

get "/search" do 
  @search_results = []
  @search_terms = params[:query]
  
  if @search_terms
    
    @contents.size.times do |chapter_num|
      chapter = File.read("data/chp#{chapter_num + 1}.txt")
      @search_results << chapter_num if text_found_in_chapter?(chapter, @search_terms)
    end
  end

  erb(:search)
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  
  erb :home
end

get "/chapters/:number" do
  chapter_num = params[:number].to_i

  redirect "/" unless (1..@contents.size).cover?(chapter_num)

  chapter_name = @contents[chapter_num - 1]
  @title = "Chapter #{chapter_num}: #{chapter_name}"

  @chapter = File.read("data/chp#{chapter_num}.txt")


  erb :chapter
end

get "/show/:name" do 
  params[:name]
end


