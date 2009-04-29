class Study < ActiveRecord::Base

  belongs_to :investigation
  has_and_belongs_to_many :assays

  has_one :project, :through=>:investigation

  belongs_to :person_responsible, :class_name => "Person"


  validates_presence_of :title
  validates_presence_of :investigation

  acts_as_solr(:fields=>[:description,:title]) if SOLR_ENABLED

end
