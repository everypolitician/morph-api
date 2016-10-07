require 'morph_scraper/version'

require 'mechanize'

class MorphScraper
  def initialize(scraper)
    @scraper = scraper
  end

  def authenticate_with_github(username: ENV['MORPH_GITHUB_USERNAME'], password: ENV['MORPH_GITHUB_PASSWORD'])
    login = agent.get('https://morph.io/users/auth/github')
    login.form['login'] = username
    login.form['password'] = password
    oauth = login.form.submit
    response = oauth.link.click
    response.code == '200'
  end

  def run_scraper
    response = agent.get("https://morph.io/#{scraper}").forms[1].submit
    response.code == '200'
  end

  def environment_variables
    page = agent.get("https://morph.io/#{scraper}/settings")
    names = page.css('#variables .row .scraper_variables_name input').map { |name| name['value'] }
    values = page.css('#variables .row .scraper_variables_value textarea').map { |value| value.text.strip }
    Hash[names.zip(values)]
  end

  private

  attr_reader :scraper

  def agent
    @agent ||= Mechanize.new
  end
end
