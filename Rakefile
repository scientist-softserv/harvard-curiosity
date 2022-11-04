# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

require 'solr_wrapper/rake_task' unless Rails.env.production?

namespace :spotlight do
  desc 'Remove all resources, sidecars, and index data'
  task clear_all: :environment do
    puts '-----------removing Resources-------------'
    Spotlight::Resource.destroy_all
    puts '------------removing Sidecars-------------'
    Spotlight::SolrDocumentSidecar.destroy_all

    puts '--------removing solr index data----------'
    Blacklight.default_index.connection.delete_by_query('*:*')
    Blacklight.default_index.connection.commit
    puts '-----------------Complete-----------------'
  end
end
