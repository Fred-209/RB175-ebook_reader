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
    str.split("\n\n").map.with_index do |paragraph, idx| 
      "<p id=#{idx}>#{paragraph}</p>"
    end
  end

  def paragraphs_matching_search(chapter, search_terms)
    list = []
    in_paragraphs(chapter).each do |paragraph|
      list << paragraph if paragraph.match?(/#{search_terms}/)
    end
    list.empty? ? nil : list
  end
end

get "/search" do 
  @search_results = {}
  @search_terms = params[:query]
  
  if @search_terms
    
    @contents.size.times do |chapter_num|
      chapter_num += 1
      chapter = File.read("data/chp#{chapter_num }.txt")
      @search_results[chapter_num] = paragraphs_matching_search(chapter, @search_terms)
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


