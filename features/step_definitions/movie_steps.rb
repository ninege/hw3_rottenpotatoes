# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    # title, rating, release_date
    m = Movie.new(movie)
    m.save()
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page
Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  assert page.body.match(/#{e1}.*#{e2}/m), "#{e1} should come before #{e2}"
end

Then /the movies should be sorted by "(.*)"/ do |field|
  prev=""
  Movie.find(:all, :order => field).each do |movie|
    curr = movie.send(field)
    step "I should see \"#{prev}\" before \"#{curr}\"" if prev != ""
    prev = curr 
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(/\s*,\s*/).each do |rating|
    step "I #{uncheck}check \"ratings_#{rating}\""
  end 
end

Then /^(?:|I )should see \/([^\/]*)\/ inside of (.*)$/ do |regexp,element|
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_xpath("//*/#{element}", :text => regexp)
  else
    assert page.has_xpath?("//*/#{element}", :text => regexp)
  end
end

Then /^(?:|I )should not see \/([^\/]*)\/ inside of (.*)$/ do |regexp,element|
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_no_xpath("//*/#{element}", :text => regexp)
  else
    assert page.has_no_xpath?("//*/#{element}", :text => regexp)
  end
end

Then /^(?:|I )should see all of the movies$/ do 
  Movie.find(:all).each do |movie|
    step "I should see \"#{movie.title}\""    
  end 
end

Then /^(?:|I )should see none of the movies$/ do 
  Movie.find(:all).each do |movie|
    step "I should not see \"#{movie.title}\""    
  end 
end