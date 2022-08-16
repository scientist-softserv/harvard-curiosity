class AddUrnToSpotlightSolrDocumentSidecars < ActiveRecord::Migration[6.1]
  def change
    add_column :spotlight_solr_document_sidecars, :urn, :string
  end
end