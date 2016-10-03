# Morph API

This is an unofficial API for https://morph.io/.

## Usage

Currently this can just trigger a run of a scraper. Pass the scraper slug (`username/scrapername`) to the `scraper.rb` script and provide a `GITHUB_USERNAME` and `GITHUB_PASSWORD` in the environment.

    GITHUB_USERNAME=changeme GITHUB_PASSWORD=secret bundle exec ruby scraper.rb chrismytton/denmark-folketing-wikidata
