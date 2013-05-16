#DO NOT EDIT THIS FILE.
#TO MODIFY THE DEFAULT SETTINGS, COPY seek_local.rb.pre to seek_local.rb AND EDIT THAT FILE INSTEAD

require 'object'
require 'asset'
require 'calendar_date_select'
require 'object'
require 'active_record_extensions'
require 'acts_as_taggable_extensions'
require 'acts_as_isa'
require 'acts_as_yellow_pages'
require 'seek/acts_as_uniquely_identifiable'
require 'acts_as_favouritable'
require 'acts_as_asset'
require 'send_subscriptions_when_activity_logged'
require 'send_notification_emails_when_announcement_created'
require 'modporter_extensions'
require "attachment_fu_extension"
require 'seek/taggable'
require "bio"
require 'assets_common_extension'
require 'sunspot_rails'
require 'cancan'
require 'in_place_editing'
require 'seek/breadcrumbs'
require 'string_extension'
require 'acts_as_list'
require 'acts_as_trashable'
require 'acts_as_tree'
#require 'fleximage'
require 'country-select'
require 'will_paginate'
require 'piwik_analytics'
require 'responds_to_parent'
require 'pothoven-attachment_fu'

require 'rightfield/rightfield'
require 'seek/rdf/rdf_generation'
require 'background_reindexing'
require 'subscribable'
require 'seek/permissions/publishing_permissions'

SEEK::Application.configure do
  GLOBAL_PASSPHRASE="ohx0ipuk2baiXah" unless defined? GLOBAL_PASSPHRASE

  ASSET_ORDER = ['Person', 'Project', 'Institution', 'Investigation', 'Study', 'Assay', 'Sample','Specimen','Strain', 'DataFile', 'Model', 'Sop', 'Publication', 'Presentation','SavedSearch', 'Organism', 'Event']

  PORTER_SECRET = "" unless defined? PORTER_SECRET

  Seek::Config.propagate_all

#these inflections are put here, because the config variables are just loaded after the propagation
  ActiveSupport::Inflector.inflections do |inflect|
    inflect.human 'Specimen', Seek::Config.sample_parent_term.capitalize  unless Seek::Config.sample_parent_term.blank?
    inflect.human 'specimen', Seek::Config.sample_parent_term.capitalize  unless Seek::Config.sample_parent_term.blank?
  end


  Annotations::Config.attribute_names_to_allow_duplicates.concat(["tag"])
  Annotations::Config.versioning_enabled = false

  ENV['LANG'] = 'en_US.UTF-8'

  if ActiveRecord::Base.connection.table_exists? 'delayed_jobs'
    SendPeriodicEmailsJob.create_initial_jobs
  end

  ConvertOffice::ConvertOfficeConfig.options =
      {
          :java_bin=>"java",
          :soffice_port=>8100,
          :nailgun=>false,
          :verbose=>false,
          :asynchronous=>false
      }

end


