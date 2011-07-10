class DocumentosController < ApplicationController
  def index
   # list
    #render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @documento_pages, @documentos = paginate :documentos, :per_page => 10
  end

  def show
    @documento = Documento.find(params[:id])
  end

  def new
    @documento = Documento.new
  end

  def create
    @documento = Documento.new(params[:documento])
    if @documento.save
      flash[:notice] = 'Documento was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @documento = Documento.find(params[:id])
  end

  def update
    @documento = Documento.find(params[:id])
    if @documento.update_attributes(params[:documento])
      flash[:notice] = 'Documento was successfully updated.'
      redirect_to :action => 'show', :id => @documento
    else
      render :action => 'edit'
    end
  end

  def destroy
    Documento.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
#-------------------------------------------------------------------------

  def swf
    redirect_to("/swf.html") 
  end

  def tipos
      redirect_to("/tipos")  
  end
  
  def areas
      redirect_to("/areas")  
  end

  def cadastra
    documento = Documento.create(params[:documento])
  if(documento.save)
    $id = documento.id.to_s
    render :text => "ok_cadastro"
  else
    if !documento.errors.empty?
      render :xml => documento.errors.to_xml_full
    else
      render :text => "erro_cadastro"
    end
  end
 end
 
  def pesquisaQtd
  documentos = Documento.find(:all)
  if documentos.size < 0
   render :text => "erro_pesquisa"
  else
   render :text => ((documentos.size + 1) / 2).to_s
  end
 end  
 
 def pesquisa
  documentos = Documento.find(:all, :include => [:tipo,:area], :limit => 50, :offset=> 0, :order => "documentos.created_at DESC")
  if documentos.size < 0
   render :text => "erro_pesquisa"
  else
   render :xml => documentos.to_xml(:include => [:tipo,:area])
  end
 end 

 def pesquisaDescricao
  documentos = Documento.find(:all, :include => [:tipo,:area], :conditions=>["docdescricao like ?","%"+params[:docdescricao]+"%"], :order => "docdescricao")
  if documentos.size < 0
   render :text => "erro_pesquisa"
  else
   render :xml => documentos.to_xml(:include => [:tipo,:area])
  end
 end 

 def pesquisaAutor
  documentos = Documento.find(:all, :include => [:tipo,:area], :conditions=>["docautor like ?","%"+params[:docautor]+"%"], :order => "docdescricao")
  if documentos.size < 0
   render :text => "erro_pesquisa"
  else
   render :xml => documentos.to_xml(:include => [:tipo,:area])
  end
 end 

 def pesquisaPalavra
  documentos = Documento.find(:all, :include => [:tipo,:area], :conditions=>["docpalavras_chave like ?","%"+params[:palavra]+"%"], :order => "docdescricao")
  if documentos.size < 0
   render :text => "erro_pesquisa"
  else
   render :xml => documentos.to_xml(:include => [:tipo,:area])
  end
 end 

 def pesquisaArea
  documentos = Documento.find(:all, :include => [:tipo,:area], :conditions=>["area_id = ?",params[:area_id]], :order => "docdescricao")
  if documentos.size < 0
   render :text => "erro_pesquisa"
  else
   render :xml => documentos.to_xml(:include => [:tipo,:area])
  end
 end 
 
 def pesquisaTipo
  documentos = Documento.find(:all, :include => [:tipo,:area], :conditions=>["tipo_id = ?",params[:tipo_id]], :order => "docdescricao")
  if documentos.size < 0
   render :text => "erro_pesquisa"
  else
   render :xml => documentos.to_xml(:include => [:tipo,:area])
  end
 end 
 
 
 #-------------------------------------------------------------------------------
 
  def upload
     render(:xml => "") if salvarArquivo(params[:Filedata],params[:Filename].to_s)
  end

  def salvarArquivo(pFile,pFileName)
  	vFilePath = "public/upload/"
  	FileUtils.mkdir(vFilePath+$id)
  	return false unless File.open(vFilePath+$id+"/"+pFileName, "wb") { |vBuffer| vBuffer.write(pFile.read) }
  	return true
  end
  

end
