require 'bundler/setup'
require 'mechanize'
require 'pry'
require 'dotenv'

Dotenv.load

class MorphAPI
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

  def set_environment_variable(scraper, name, value)
    page = agent.get("https://morph.io/#{scraper}/settings")
    form = page.forms[1]
    binding.pry
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

morph = MorphAPI.new(username: ENV['GITHUB_USERNAME'], password: ENV['GITHUB_PASSWORD'])

morph.__send__(*ARGV)
