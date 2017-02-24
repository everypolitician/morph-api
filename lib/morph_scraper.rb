require 'morph_scraper/version'
require 'morph_scraper/environment_variables_form'

require 'mechanize'

class MorphScraper
  class Scraper
    def initialize(agent:, scraper:)
      @agent = agent
      @scraper = scraper
    end

    def exists_on_morph?
      agent.get("https://morph.io/#{scraper}")
      true
    rescue Mechanize::ResponseCodeError
      false
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
      form = EnvironmentVariablesForm.new(form: settings_page.forms[1])
      form.set(name, value)
    end

    private

    attr_reader :agent, :scraper

    def settings_page
      agent.get("https://morph.io/#{scraper}/settings")
    end
  end

  def initialize(
    username: ENV['MORPH_GITHUB_USERNAME'],
    password: ENV['MORPH_GITHUB_PASSWORD']
  )
    @username = username
    @password = password
  end

  def scraper(scraper)
    Scraper.new(agent: agent, scraper: scraper)
  end

  private

  attr_reader :username, :password

  def agent
    @agent ||= Mechanize.new.tap do |mech|
      login = mech.get('https://morph.io/users/auth/github')
      login.form['login'] = username
      login.form['password'] = password
      oauth = login.form.submit
      response = oauth.link.click
      response.code == '200'
    end
  end
end
