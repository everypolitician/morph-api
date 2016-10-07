require 'morph_scraper/version'

require 'mechanize'

class MorphScraper
  def initialize(username:, password:)
    @username = username
    @password = password
    sign_in_with_github
  end

  def run_scraper(scraper)
    agent.get("https://morph.io/#{scraper}").forms[1].submit
  end

  def environment_variables(scraper)
    page = agent.get("https://morph.io/#{scraper}/settings")
    names = page.css('#variables .row .scraper_variables_name input').map { |name| name['value'] }
    values = page.css('#variables .row .scraper_variables_value textarea').map { |value| value.text.strip }
    puts names.zip(values).map { |k, v| "#{k}=#{v}" }
  end

  private

  attr_reader :username, :password

  def sign_in_with_github
    github_oauth = agent.get('https://morph.io/users/auth/github')
    github_oauth.form['login'] = username
    github_oauth.form['password'] = password
    oauth = github_oauth.form.submit
    oauth.link.click
  end

  def agent
    @agent ||= Mechanize.new
  end
end
