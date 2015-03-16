module Seek
  module ResearchObjects
    # shared utility methods useful for RO generation
    module Utils
      # defines an ROBundle::Agent for the person, or the current logged in user
      def create_agent(person = User.current_user.try(:person))
        return if person.nil?
        person = person.person if person.is_a?(User)
        ROBundle::Agent.new(person.title, person.rdf_resource.to_uri.to_s, person.orcid_uri)
      end

      # returns the content-blobs
      def asset_blobs(asset)
        asset.respond_to?(:content_blob) ? [asset.content_blob] : asset.content_blobs
      end
    end
  end
end