class MorphScraper
  class EnvironmentVariablesForm
    def initialize(form:)
      @form = form
    end

    def set(name, value)
      existing = form.fields.find { |f| f.value == name }
      if existing
        form[existing.name.sub(/\[name\]$/, '[value]')] = value
      else
        set_form_env_var(name, value)
      end
      clean_textareas
      form.submit
      value
    end

    private

    attr_reader :form

    def set_form_env_var(name, value)
      field_id = Time.now.to_i
      form["scraper[variables_attributes][#{field_id}][name]"] = name
      form["scraper[variables_attributes][#{field_id}][value]"] = value
    end

    def clean_textareas
      # Workaround for Morph adding a newline to the beginning of a textarea.
      form.textareas.each { |t| t.value = t.value.strip }
    end
  end
end
