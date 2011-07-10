// ActionScript file
//Imports -----------------------------------------------
	import mx.managers.PopUpManager;
	import mx.events.CloseEvent;
	import mx.controls.Alert;
    import mx.events.ValidationResultEvent;
    import mx.rpc.http.mxml.HTTPService;
    import flash.events.Event;
    import mx.controls.Alert;
    import mx.rpc.AsyncResponder;
    import mx.rpc.AsyncToken;
    import mx.rpc.events.ResultEvent; 
//Variáveis ---------------------------------------------
	 [Bindable]
	 public var pesquisaAreaService:HTTPService;
	 
	 [Bindable]
	 public var pesquisaTipoService:HTTPService;

   
//Funções -----------------------------------------------
	
	public function init():void{
		PopUpManager.centerPopUp(this);
		pesquisaArea();
		pesquisaTipo();
	}
	   
	public function close():void{
         effectClose.play();
		 //PopUpManager.removePopUp(this);
	}	   

    private function theEnd():void{
		PopUpManager.removePopUp(this);      	
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

    private function resultPesquisa(event:Event):void{
		 if(pesquisaAreaService.lastResult=="erro_pesquisa"){
		 	Alert.show("Nenhum registro encontrado para a pesquisa solicitada.");
		 }
		 if(pesquisaTipoService.lastResult=="erro_pesquisa"){
		 	Alert.show("Nenhum registro encontrado para a pesquisa solicitada.");
		 }
    }
    
    public function pesquisar():void{
    	switch (radiogroup1.selectedValue){
    		case 1:
    			parentDocument._mainView.pesquisaGrid(radiogroup1.selectedValue,_txt_descricao.text);
    			break;
    		case 2:
    			parentDocument._mainView.pesquisaGrid(radiogroup1.selectedValue,_txt_autor.text);
    			break;
    		case 3:
    			parentDocument._mainView.pesquisaGrid(radiogroup1.selectedValue,_txt_palavra.text);
    			break;
    		case 4:
    			parentDocument._mainView.pesquisaGrid(radiogroup1.selectedValue,_cmb_Area.selectedItem.id);
    			break;
    		case 5:
		    	parentDocument._mainView.pesquisaGrid(radiogroup1.selectedValue,_cmb_Tipo.selectedItem.id);
		    	break;
    	}
    	
    	close();
    } 