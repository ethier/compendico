module TemplateParser
  extend ActiveSupport::Concern

  included do
    def parsed_template
      @parsed_template ||= Liquid::Template.parse(template.markup)
    end
  end
end
