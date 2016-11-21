require 'morph_scraper/version'

require 'mechanize'

class MorphScraper
  def initialize(scraper)
    @scraper = scraper
  end

  def authenticate_with_github(
    username: ENV['MORPH_GITHUB_USERNAME'],
    password: ENV['MORPH_GITHUB_PASSWORD']
  )
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
    page = settings_page
    names = page.css('#variables .row .scraper_variables_name input').map { |name| name['value'] }
    values = page.css('#variables .row .scraper_variables_value textarea').map { |value| value.text.strip }
    Hash[names.zip(values)]
  end

  def set_environment_variable(name, value)
    page = agent.get("https://morph.io/#{scraper}/settings")
    form = page.forms[1]
    existing = form.fields.find { |f| f.value == name }
    if existing
      form[existing.name.sub(/\[name\]$/, '[value]')] = value
    else
      field_id = Time.now.to_i
      form["scraper[variables_attributes][#{field_id}][name]"] = name
      form["scraper[variables_attributes][#{field_id}][value]"] = value
    end
    response = form.submit
    response.code == '200'
  end

  private

  attr_reader :scraper

  def settings_page
    agent.get("https://morph.io/#{scraper}/settings")
  end

  def agent
    @agent ||= Mechanize.new
  end
end
