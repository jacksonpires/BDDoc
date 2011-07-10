class AreasController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @area_pages, @areas = paginate :areas, :per_page => 10
  end

  def show
    @area = Area.find(params[:id])
  end

  def new
    @area = Area.new
  end

  def create
    @area = Area.new(params[:area])
    if @area.save
      flash[:notice] = 'Area was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @area = Area.find(params[:id])
  end

  def update
    @area = Area.find(params[:id])
    if @area.update_attributes(params[:area])
      flash[:notice] = 'Area was successfully updated.'
      redirect_to :action => 'show', :id => @area
    else
      render :action => 'edit'
    end
  end

  def destroy
    Area.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
#-----------------------------------------------------------------

 def pesquisa
   areas = Area.find(:all, :order=>"areadescricao")
   if areas.size < 0
    render :text => "erro_pesquisa"
   else
    render :xml => areas.to_xml
   end
 end
  
end