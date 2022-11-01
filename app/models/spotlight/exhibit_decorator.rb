# frozen_string_literal: true

module Spotlight
  # OVERRIDE: (Spotlight v3.3.0) Use custom decorator to change default metadata field configurations.
  #
  # An Exhibit's metadata configuration (found at /<exhibit_slug>/metadata_configuration/edit) is saved
  # in @exhibit.blacklight_configuration.index_fields. By default, this is set to
  # an empty Hash when an Exhibit is created.
  #
  # CURIOSity has a custom metadata config defined in lib/spotlight_exhibit_decorator_default_field_config.json.
  # The format of that file matches the format expected by @exhibit.blacklight_configuration.index_fields.
  # With this decorator, the custom configurations will get loaded into an Exhibit when it gets created.
  # This effectively overrides all newly created Exhibits' default metadata configurations.
  #
  # Changes made to an Exhibit's metadata configuration through the UI will be respected.
  module ExhibitDecorator
    # Set up after_create callback on Spotlight::Exhibit
    def self.prepended(base)
      base.class_eval do
        has_many :harvesters, dependent: :destroy, class_name: '::Spotlight::Harvester'

        after_create :load_default_field_config
      end
    end

    # Pull the custom CURIOUSity metadata field configurations and load them into the Exhibit's
    # associated Spotlight::BlacklightConfiguration record.
    def load_default_field_config
      blacklight_configuration.index_fields = JSON.parse(File.read('lib/spotlight_exhibit_decorator_default_field_config.json'))

      blacklight_configuration.index_fields.each_key do |field_name|
        # Instead of hard-coding labels in the JSON file, use the configured I18n labels
        blacklight_configuration.index_fields[field_name].merge!('label' => I18n.t("spotlight.search.fields.#{field_name}"))
      end

      blacklight_configuration.save!
    end
  end
end

Spotlight::Exhibit.prepend(Spotlight::ExhibitDecorator)
