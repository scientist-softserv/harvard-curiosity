module Spotlight
  # OVERRIDE ExhibitImportExportService from Spotlight v3.3.0
  module ExhibitImportExportServiceDecorator # rubocop:disable Metrics/ModuleLength
    # OVERRIDE: re-attach associated records after resetting Exhibit.id
    def from_hash!(hash) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
      hash = hash.deep_symbolize_keys.reverse_merge(
        main_navigations: {},
        contact_emails: {},
        searches: {},
        about_pages: {},
        feature_pages: {},
        contacts: {},
        custom_fields: {},
        solr_document_sidecars: {},
        resources: {},
        attachments: {},
        languages: {},
        translations: {},
        owned_taggings: {},
        groups: {}
      )

      # OVERRIDE: grab each associated record to update after exhibit is updated
      associations = %i[
        blacklight_configuration
        main_navigations
        contact_emails
        searches
        about_pages
        feature_pages
        home_page
        contacts
        custom_fields
        solr_document_sidecars
        resources
        attachments
        languages
        translations
        owned_taggings
        groups
      ]
      associated_records = []
      associations.each do |association|
        associated_records << exhibit.send(association)
      end

      exhibit_attributes = hash.reject { |_k, v| v.is_a?(Array) || v.is_a?(Hash) }
      # OVERRIDE: #update wasn't persisting changes, use #assign_attributes + #save! instead
      exhibit.assign_attributes(exhibit_attributes.except(:theme))
      exhibit.save!
      exhibit.theme = exhibit_attributes[:theme] if exhibit.themes.include? exhibit_attributes[:theme]

      # OVERRIDE: update each associated record's :exhibit_id to be the new ID
      associated_records.flatten.each do |ar|
        next if ar.blank?

        ar.exhibit = exhibit
        ar.save!
      end

      deserialize_featured_image(exhibit, :masthead, hash[:masthead]) if hash[:masthead]
      deserialize_featured_image(exhibit, :thumbnail, hash[:thumbnail]) if hash[:thumbnail]

      # OVERRIDE: filter out incoming facets that conflict with default facets before updating
      if blacklight_configuration_hash = hash[:blacklight_configuration]&.with_indifferent_access.presence
        non_default_facets = blacklight_configuration_hash[:facet_fields].except(*exhibit.blacklight_config.facet_field_names)
        blacklight_configuration_hash[:facet_fields] = non_default_facets

        exhibit.blacklight_configuration.update(blacklight_configuration_hash)
      end

      hash[:main_navigations].each do |attr|
        ar = exhibit.main_navigations.find_or_initialize_by(nav_type: attr[:nav_type])
        ar.update(attr)
      end

      hash[:contact_emails].each do |attr|
        ar = exhibit.contact_emails.find_or_initialize_by(email: attr[:email])
        ar.update(attr)
      end

      hash[:groups].each do |attr|
        gr = exhibit.groups.find_or_initialize_by(slug: attr[:slug])
        gr.update(attr)
      end

      hash[:searches].each do |attr|
        group_slugs = attr.delete(:group_slugs) || []
        masthead = attr.delete(:masthead)
        thumbnail = attr.delete(:thumbnail)

        ar = exhibit.searches.find_or_initialize_by(slug: attr[:slug])
        ar.update(attr)

        ar.update(groups: exhibit.groups.select { |x| group_slugs.include? x.slug })

        deserialize_featured_image(ar, :masthead, masthead) if masthead
        deserialize_featured_image(ar, :thumbnail, thumbnail) if thumbnail
      end

      hash[:about_pages].each do |attr|
        masthead = attr.delete(:masthead)
        thumbnail = attr.delete(:thumbnail)
        translated_pages = attr.delete(:translated_pages) || []

        ar = exhibit.about_pages.find_or_initialize_by(slug: attr[:slug])
        ar.update(attr)

        deserialize_featured_image(ar, :masthead, masthead) if masthead
        deserialize_featured_image(ar, :thumbnail, thumbnail) if thumbnail

        translated_pages.each do |tattr|
          masthead = tattr.delete(:masthead)
          thumbnail = tattr.delete(:thumbnail)

          tar = ar.translated_page_for(tattr[:locale]) || ar.clone_for_locale(tattr[:locale])
          tar.update(tattr)

          deserialize_featured_image(ar, :masthead, masthead) if masthead
          deserialize_featured_image(ar, :thumbnail, thumbnail) if thumbnail
        end
      end

      # OVERRIDE: fix feature/child page JSON issue when importing exhibits from earlier spotlight versions.
      # In earlier versions of spotlight, the JSON files included nested child_pages.
      # In this version, the child_pages are just feature_pages that have a parent_page_slug.
      # This block handles child_pages and turns them into feature_pages so they can be imported
      child_pages_array = []
      hash[:feature_pages].each do |attr|
        next if attr[:child_pages].blank?

        parent_page_slug_hash = { parent_page_slug: attr[:slug] }
        attr[:child_pages].each do |child_page|
          child_page.merge!(parent_page_slug_hash)
          child_page.delete(:child_pages)
          child_pages_array.push(child_page)
        end
        attr.delete(:child_pages)
      end
      hash[:feature_pages].concat(child_pages_array)

      hash[:feature_pages].each do |attr|
        masthead = attr.delete(:masthead)
        thumbnail = attr.delete(:thumbnail)

        ar = exhibit.feature_pages.find_or_initialize_by(slug: attr[:slug])
        ar.update(attr.except(:parent_page_slug, :translated_pages))

        deserialize_featured_image(ar, :masthead, masthead) if masthead
        deserialize_featured_image(ar, :thumbnail, thumbnail) if thumbnail
      end

      feature_pages = exhibit.feature_pages.index_by(&:slug)
      hash[:feature_pages].each do |attr|
        feature_pages[attr[:slug]].parent_page_id = feature_pages[attr[:parent_page_slug]].id if attr[:parent_page_slug]

        ar = exhibit.feature_pages.find_or_initialize_by(slug: attr[:slug])

        (attr[:translated_pages] || []).each do |tattr|
          masthead = tattr.delete(:masthead)
          thumbnail = tattr.delete(:thumbnail)

          tar = ar.translated_page_for(tattr[:locale]) || ar.clone_for_locale(tattr[:locale])
          tar.update(tattr)

          deserialize_featured_image(ar, :masthead, masthead) if masthead
          deserialize_featured_image(ar, :thumbnail, thumbnail) if thumbnail
        end
      end

      if hash[:home_page]
        translated_pages = hash[:home_page].delete(:translated_pages) || []
        exhibit.home_page.update(hash[:home_page].except(:thumbnail))
        deserialize_featured_image(exhibit.home_page, :thumbnail, hash[:home_page][:thumbnail]) if hash[:home_page][:thumbnail]

        translated_pages.each do |tattr|
          masthead = tattr.delete(:masthead)
          thumbnail = tattr.delete(:thumbnail)

          tar = exhibit.home_page.translated_page_for(tattr[:locale]) || exhibit.home_page.clone_for_locale(tattr[:locale])
          tar.update(tattr)

          deserialize_featured_image(ar, :masthead, masthead) if masthead
          deserialize_featured_image(ar, :thumbnail, thumbnail) if thumbnail
        end
      end

      hash[:contacts].each do |attr|
        avatar = attr.delete(:avatar)

        ar = exhibit.contacts.find_or_initialize_by(slug: attr[:slug])
        ar.update(attr)

        deserialize_featured_image(ar, :avatar, avatar) if avatar
      end

      # OVERRIDE: skip importing duplicate fields that cause issues
      default_fields = Spotlight::Engine.config.upload_fields.map(&:field_name).map(&:to_s)
      hash[:custom_fields].each do |attr|
        next if default_fields.include?(attr[:field])

        ar = exhibit.custom_fields.find_or_initialize_by(slug: attr[:slug])
        ar.update(attr)
      end

      hash[:solr_document_sidecars].each do |attr|
        ar = exhibit.solr_document_sidecars.find_or_initialize_by(document_id: attr[:document_id])
        ar.update(attr)
      end

      hash[:resources].each do |attr|
        # OVERRIDE: convert old Harvesters into new OaipmhHarvesters
        if attr[:type] == 'Spotlight::Resources::Harvester'
          attr[:mapping_file] = if File.file?("public/uploads/modsmapping/#{attr&.[](:data)&.[](:mapping_file)}")
                                  attr&.[](:data)&.[](:mapping_file)
                                else
                                  'Default Mapping File'
                                end
          attr[:base_url] = attr&.[](:data)&.[](:base_url)
          attr[:type] = attr&.[](:data)&.[](:type)
          attr[:set] =  attr&.[](:data)&.[](:set)
          attr[:metadata_type] = attr&.[](:data)&.[](:type)
          attr[:user_id] = attr&.[](:data)&.[](:user)&.[](:id)

          Spotlight::OaipmhHarvester.create(exhibit: exhibit, **attr.except(:type, :data, :url))
        else
          upload = attr.delete(:upload)

          ar = exhibit.resources.find_or_initialize_by(type: attr[:type], url: attr[:url])
          ar.update(attr)

          deserialize_featured_image(ar, :upload, upload) if upload
        end
      end

      hash[:attachments].each do |attr|
        file = attr.delete(:file)

        # dedupe by something??
        ar = exhibit.attachments.build(attr)
        ar.file = CarrierWave::SanitizedFile.new tempfile: StringIO.new(Base64.decode64(file[:content])),
                                                 filename: file[:filename],
                                                 content_type: file[:content_type]
      end

      hash[:languages].each do |attr|
        ar = exhibit.languages.find_or_initialize_by(locale: attr[:locale])
        ar.update(attr)
      end

      hash[:translations].each do |attr|
        ar = exhibit.translations.find_or_initialize_by(locale: attr[:locale], key: attr[:key])
        ar.update(attr)
      end

      hash[:owned_taggings].each do |attr|
        tag = ActsAsTaggableOn::Tag.find_or_create_by(name: attr[:tag][:name])
        exhibit.owned_taggings.build(attr.except(:tag).merge(tag_id: tag.id))
      end
    end

    # OVERRIDE: replace incoming, hard-coded base url with dynamic env variable
    def deserialize_featured_image(obj, method, data)
      file = data.delete(:image)
      image = obj.public_send("build_#{method}")
      # OVERRIDE BEGIN
      data[:iiif_tilesource] = transform_featured_image_base_url(data.fetch(:iiif_tilesource))
      # OVERRIDE END
      image.update(data)
      if file
        image.image = CarrierWave::SanitizedFile.new tempfile: StringIO.new(Base64.decode64(file[:content])),
                                                     filename: file[:filename],
                                                     content_type: file[:content_type]
        # Unset the iiif_tilesource field as the new image should be different, because
        # the source has been reloaded
        image.iiif_tilesource = nil
      end
      image.save!
      obj.update(method => image)
    end

    # OVERRIDE: add new method to replace an image's base url if APP_HOST is configured
    def transform_featured_image_base_url(base_url)
      return base_url if ENV.fetch('APP_HOST', nil).blank?

      base_url.gsub('https://curiosity.lib.harvard.edu/images', "https://#{ENV.fetch('APP_HOST')}/images")
    end
  end
end

Spotlight::ExhibitImportExportService.prepend(Spotlight::ExhibitImportExportServiceDecorator)
