// ActionScript file

//Imports ---------------------------------------------
       import mx.managers.PopUpManager;
	   import mx.collections.ArrayCollection;
	   import mx.validators.Validator;
	   import mx.events.ValidationResultEvent;
	   import mx.rpc.http.mxml.HTTPService;
	   import flash.events.Event;
	   import mx.controls.Alert;
	   import mx.rpc.AsyncResponder;
	   import mx.rpc.AsyncToken;
	   import mx.rpc.events.ResultEvent; 
	   import br.com.bddoc.utils.ServerErrors;
	   import br.com.bddoc.NovoDocumento;
	   import flash.net.FileReference;
	   import flash.net.FileReference;
	   import flash.net.URLRequestHeader;
	   import flash.net.URLRequest;
	   import flash.events.Event;
	   import flash.events.ProgressEvent;
	   import flash.events.IOErrorEvent;
	   import mx.events.CloseEvent;
	   import br.com.bddoc.Main;
	   import mx.core.Application;
	   import flash.system.System;
	   
//Função INIT() e CLOSE() -----------------------------------------------------------

		public function init():void{
			PopUpManager.centerPopUp(this);
			_txt_descricao.setFocus();
			pesquisaArea(); 
			pesquisaTipo();
		}
		
		public function close():void{
			Alert.yesLabel="Sim";
			Alert.noLabel="Não";
			Alert.show("Deseja realmente cancelar?", "Pergunta", (Alert.YES | Alert.NO), this, alertClickHandlerClose);
		}	   
	   
        private function alertClickHandlerClose(event:CloseEvent):void {
                if (event.detail==Alert.YES){
                   effectClose.play();
                }    
        }
        
        private function theEnd():void{
			PopUpManager.removePopUp(this);      	
        }            

//Funções de Cadastro/Pesquisa ----------------------------------------------      
		 
 		 [Bindable]
		 public var pesquisaAreaService:HTTPService;
		 
 		 [Bindable]
		 public var pesquisaTipoService:HTTPService;

		 [Bindable]
		 private var _serverErrors:ServerErrors;
		 
		 public var cadDocumentoService:HTTPService;	 
         public var documento:Object;
         public var idDocumento:String;
         
		 public var textTypes:FileFilter = new FileFilter("Documentos (*.doc, *.txt, *.rtf, *.pdf, *.xls, *.ppt, *.pps)", "*.doc; *.txt; *.rtf; *.pdf; *.xls; *.ppt, *.pps");
		 public var allTypes:Array = new Array(textTypes);

	    public function openDialog():void {
	     	//var myFileReference:FileReference = new FileReference();
		   // myFileReference.browse(allTypes);
			uploadFiles();
	    }	
	     
		private function pesquisaArea():void{
			 pesquisaAreaService = new HTTPService();
			 pesquisaAreaService.useProxy = false;
			 pesquisaAreaService.method = "GET";
			 pesquisaAreaService.url = "/areas/pesquisa";
			 pesquisaAreaService.showBusyCursor=true;
			 pesquisaAreaService.send();
			 pesquisaAreaService.addEventListener(ResultEvent.RESULT, resultPesquisa);
	    }
	    
		private function pesquisaTipo():void{
			 pesquisaTipoService = new HTTPService();
			 pesquisaTipoService.useProxy = false;
			 pesquisaTipoService.method = "GET";
			 pesquisaTipoService.url = "/tipos/pesquisa";
			 pesquisaTipoService.showBusyCursor=true;
			 pesquisaTipoService.send();
			 pesquisaTipoService.addEventListener(ResultEvent.RESULT, resultPesquisa);
	    }

        public function resultPesquisa(event:Event):void{
         if(pesquisaAreaService.lastResult=="erro_pesquisa"){
           Alert.show("Nenhum registro encontrado para a pesquisa solicitada.");
         }
         if(pesquisaTipoService.lastResult=="erro_pesquisa"){
           Alert.show("Nenhum registro encontrado para a pesquisa solicitada.");
         }
         
        }
	    
		private function cadastrar():void{

			 desativarControles();

			 cadDocumentoService = new HTTPService();
			 cadDocumentoService.useProxy = false;
			 cadDocumentoService.method = "POST";
			 cadDocumentoService.resultFormat= "e4x"
			 cadDocumentoService.url = "/documentos/cadastra";
			 
			 documento = new Object();

	         documento['documento[docdescricao]'] 		=  _txt_descricao.text;
             documento['documento[docautor]'] 			=  _txt_autor.text;
             documento['documento[area_id]'] 		=  _cmb_area.selectedItem.id;
             documento['documento[tipo_id]'] 		=  _cmb_tipo.selectedItem.id;
             documento['documento[docpalavras_chave]'] =  _txt_palavras_chave.text;
             documento['documento[docsinopse]'] 		=  _txt_sinopse.text;
             documento['documento[docarquivo]'] 	=  _txt_url_arquivo.text;
             
			 cadDocumentoService.showBusyCursor=true;
			 var token : AsyncToken = cadDocumentoService.send(documento);
			 token.addResponder(new AsyncResponder(msgResult, msgFault));
	     }		    
 
		private function msgResult(data:Object, token:Object=null):void{
			//Alert.show(data.result);
			// var s:String = data.result;
             //var params:Array = s.Split("|",2);
          	if(data.result=="ok_cadastro"){
          	 //if (params[1] == "ok_cadastro"){
          	 	 initUpload();
				 //pesquisa();
			     //Alert.show("Registro cadastrado com sucesso!");
			}else{
			  ativarControles();	
			}	
			 
			 if(data.result=="erro_cadastro"){
			     Alert.show("Houve um erro ao tentar cadastrar o registro!");
			 }	
			 
	 
			 if (data.result is XML) {
			 	var resultXML:XML = XML(data.result);
				if (resultXML.name() == "errors") {
				 Alert.show("Existem campos inválidos!");
			 	 _serverErrors = new ServerErrors(resultXML);
				}else{
				 _serverErrors = new ServerErrors(new XML);
				}
			 }
		}
		
		private function msgFault(data:Object, token:Object=null):void{
			  Alert.show("Houve um erro ao tentar processar os dados no servidor.");
			  ativarControles();
		}	 
		
		private function limpar():void{
        	_txt_descricao.text="";
        	_txt_autor.text="";
        	_cmb_area.selectedIndex=-1;
        	_cmb_tipo.selectedIndex=-1;
        	_txt_palavras_chave.text="";
        	_txt_sinopse.text="";
        	_txt_url_arquivo.text="";        	
        }

//Ativar Desativar controles ---------------------------------------------------
        
        private function desativarControles():void
        { 
        	_btn_salvar.enabled=false;
	        _btn_cancelar.enabled=false;
	        showCloseButton=false;
	        _progress_bar.visible=true;
        }
        
        private function ativarControles():void
        {
        	_btn_salvar.enabled=true;
	        _btn_cancelar.enabled=true;
	        showCloseButton=true;
	        _progress_bar.visible=false;
        }        
		    
		    
//Upload de Arquivo ----------------------------------------------------------

	   private var uploadFileRefList:FileReference = new FileReference();
	   private var uploadURLReq:URLRequest;
	   private var URLString:String="/documentos/upload";  //Nome do controler/action

	   private function uploadFiles():void
	   {
	       uploadFileRefList.addEventListener(Event.SELECT, uploadSelectHandler);
	       try {
	               var success:Boolean = uploadFileRefList.browse();
	       } catch (error:Error) {
	               trace("Não foi possível abrir o browser para selecionar os arquivos. " + error);
	               Alert.show("Não foi possível abrir o browser para selecionar os arquivos. " + error);
	       }
	   }
	   
	   private function uploadSelectHandler(event:Event):void
	   {
	   	   _txt_url_arquivo.text= uploadFileRefList.name;
	       //doUpload(uploadFileRefList);	       
       }

	   private function initUpload():void
	   {
	   		doUpload(uploadFileRefList);	
	   }

	   private function doUpload(file:FileReference):void
	   {
	       uploadURLReq = new URLRequest(URLString);
	       file.addEventListener(Event.COMPLETE, uploadCompleteHandler);
	       file.addEventListener(IOErrorEvent.IO_ERROR, uploadIoErrorHandler);
	       file.addEventListener(ProgressEvent.PROGRESS, uploadProgressHandler);
	       try
	       {
	           file.upload(uploadURLReq);
	       } catch (error:Error) {
	           trace("Não foi possível fazer o upload do arquivo. " + error);
	           Alert.show("Não foi possível fazer o upload do arquivo. " + error);
	       }
	   }
	   
	   private function uploadProgressHandler (event:ProgressEvent):void
	   {
	       //upload_btn.enabled=false;
	       trace(Math.floor((event.bytesLoaded/event.bytesTotal)*100) + "% complete");
	       _progress_bar.setProgress(Math.floor((event.bytesLoaded/event.bytesTotal)*100),100);
           _progress_bar.label= "Fazendo upload... " + Math.floor((event.bytesLoaded/event.bytesTotal)*100) + "%";
	   }
	   
	   private function uploadIoErrorHandler (event:Event):void
	   {
		   Alert.show("Falha ao tentar fazer upload: " + event);
	       ativarControles();
	   }
	   

	   private function uploadCompleteHandler (event:Event):void
	   {
	       //upload_btn.enabled=true;
			Alert.show("Cadastro efetuado com sucesso!", "Informação",Alert.OK, this, alertClickHandlerComplete);
	   }   		    
	   
       private function alertClickHandlerComplete(event:CloseEvent):void {
            if (event.detail==Alert.OK){
       	       limpar();
		       ativarControles();
			   parentDocument._mainView.init();		       		       
		       PopUpManager.removePopUp(this);
            }

       }   
