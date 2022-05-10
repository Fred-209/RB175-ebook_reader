require 'tilt/erubis'
require "sinatra"
require "sinatra/reloader"

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @contents = File.readlines("data/toc.txt")

  erb :home
end

get /\/chapters\/([0-9]+)/ do
  @chapter_num = params['captures'].first
  @title = "Chapter #{@chapter_num}"
  @contents = File.readlines("data/toc.txt")
  @chapter = File.read("data/chp#{@chapter_num}.txt")

  erb :chapter
  
end
