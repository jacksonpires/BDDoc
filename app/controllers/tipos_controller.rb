class TiposController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @tipo_pages, @tipos = paginate :tipos, :per_page => 10
  end

  def show
    @tipo = Tipo.find(params[:id])
  end

  def new
    @tipo = Tipo.new
  end

  def create
    @tipo = Tipo.new(params[:tipo])
    if @tipo.save
      flash[:notice] = 'Tipo was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @tipo = Tipo.find(params[:id])
  end

  def update
    @tipo = Tipo.find(params[:id])
    if @tipo.update_attributes(params[:tipo])
      flash[:notice] = 'Tipo was successfully updated.'
      redirect_to :action => 'show', :id => @tipo
    else
      render :action => 'edit'
    end
  end

  def destroy
    Tipo.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
#-----------------------------------------------------------------

  def pesquisa
   tipos = Tipo.find(:all, :order=>"tipodescricao")
   if tipos.size < 0
    render :text => "erro_pesquisa"
   else
    render :xml => tipos.to_xml
   end
 end
 
end
