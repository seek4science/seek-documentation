class SpecimensController < ApplicationController
  # To change this template use File | Settings | File Templates.


  before_filter :find_assets, :only => [:index]
  before_filter :find_and_auth, :only => [:show, :update, :edit, :destroy]

  include IndexPager

  def new
    @specimen = Specimen.new
    respond_to do |format|

      format.html # new.html.erb
    end
  end

  def create
    @specimen = Specimen.new(params[:specimen])

    organism = params[:specimen_organism_id] || []
    o_id =organism.split(",").first
    @specimen.organism= Organism.find o_id if o_id.kind_of?(Numeric) || o_id.kind_of?(String)

    @specimen.contributor = current_user
    @specimen.project_id = params[:project_id]

    @specimen.policy_or_default
    @specimen.policy.set_attributes_with_sharing params[:sharing]
    #Add creators
    AssetsCreator.add_or_update_creator_list(@specimen, params[:creators])

    respond_to do |format|
      if @specimen.save

        o_id, strain, culture_growth_type_text=organism.split(",")
        culture_growth=CultureGrowthType.find_by_title(culture_growth_type_text)
        @specimen.associate_organism(o_id, strain, culture_growth)

        flash[:notice] = 'Specimen was successfully created.'
        format.html { redirect_to(@specimen) }
        format.xml  { head :ok }
      else
       # Policy.create_or_update_policy(@specimen, current_user, params)
        format.html { render :action => "new" }
      end
    end
  end

  def update

    #update project
    @specimen.project_id = params[:project_id]
    organism = params[:specimen_organism_id] || []
    o_id =organism.split(",").first

    if o_id.kind_of?(Numeric) || o_id.kind_of?(String)
    @specimen.organism  = Organism.find o_id
    else
       @specimen.organism  = nil
       @specimen.strain = nil
       @specimen.culture_growth_type =nil
    end
    @specimen.contributor = current_user
    @specimen.policy.set_attributes_with_sharing params[:sharing]
    #update creators
    AssetsCreator.add_or_update_creator_list(@specimen, params[:creators])
     respond_to do |format|
      if @specimen.update_attributes params[:specimen]
           o_id, strain, culture_growth_type_text=organism.split(",")
          culture_growth=CultureGrowthType.find_by_title(culture_growth_type_text)
          @specimen.associate_organism(o_id, strain, culture_growth)

          flash[:notice] = 'Specimen was successfully updated.'
          format.html { redirect_to(@specimen) }
          format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
      end

    end
  end

  def destroy
    respond_to do |format|
      if @specimen.destroy
        format.html { redirect_to(specimens_path) }
        format.xml { head :ok }
      else
        flash.now[:error]="Unable to delete the specimen" if !@specimen.institution.nil?
        format.html { render :action=>"show" }
        format.xml { render :xml => @specimen.errors, :status => :unprocessable_entity }
      end
    end
  end


  def project_selected_ajax

    if params[:project_id] && params[:project_id]!="0"
      ins=Project.find(params[:project_id]).institutions

    end
    ins||=[]

    #render :update do |page|

     # page.replace_html "institution_collection", :partial=>"specimens/institutions_list", :locals=>{:ins=>ins, :project_id=>params[:project_id]}
    #end

  end


end

