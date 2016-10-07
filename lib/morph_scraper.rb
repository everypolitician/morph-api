require 'morph_scraper/version'

require 'mechanize'

class MorphScraper
  def initialize(
    scraper:,
    github_username: ENV['MORPH_GITHUB_USERNAME'],
    github_password: ENV['MORPH_GITHUB_PASSWORD']
  )
    @scraper = scraper
    @github_username = github_username
    @github_password = github_password
    sign_in_with_github
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

  attr_reader :scraper, :github_username, :github_password

  def sign_in_with_github
    github_oauth = agent.get('https://morph.io/users/auth/github')
    github_oauth.form['login'] = github_username
    github_oauth.form['password'] = github_password
    oauth = github_oauth.form.submit
    oauth.link.click
  end

  def agent
    @agent ||= Mechanize.new
  end
end
