require_dependency File.join(Gem.loaded_specs['acts_as_activity_logged'].full_gem_path, 'lib', 'activity_log')

class ActivityLog  < ActiveRecord::Base

  enforce_authorization_on_association :activity_loggable,:view
  serialize :data

  scope :no_spider,:conditions=>"user_agent NOT LIKE '%spider%'"

  #returns items that have duplicates for a given action - NOTE that the result does not contain all the actual duplicates.
  scope :duplicates, lambda {|action|
    {
    :select=>"id,created_at,activity_loggable_type,activity_loggable_id,action,count(activity_loggable_id+activity_loggable_type) as dup_count",
    :conditions=>"action='#{action}' and controller_name!='sessions'",
    :group=>"activity_loggable_type,activity_loggable_id having dup_count>1"
    }
  }

  def self.remove_duplicate_creates
    duplicates=ActivityLog.duplicates "create"
    duplicates.each do |duplicate|
      matches = ActivityLog.where(:activity_loggable_id=>duplicate.activity_loggable_id, :activity_loggable_type=>duplicate.activity_loggable_type, :action=>"create").order("created_at ASC")
      (1...matches.count).to_a.each do |index|
        matches[index].destroy
      end
    end
  end

  def check_loggable_is_viewable
    result = true
    if activity_loggable && !activity_loggable.can_view?
      errors.add(:base,"the asset is not viewable")
      result = false
    end
    result
  end

end