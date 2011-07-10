// ActionScript file
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
   	import mx.rpc.events.ResultEvent;
   	import mx.rpc.http.mxml.HTTPService;
   	import flash.events.Event;
   	import mx.controls.Alert;
   	import mx.controls.dataGridClasses.DataGridColumn;
   	import mx.formatters.DateFormatter;
	import mx.rpc.AsyncResponder;
	 

	[Bindable]
	public var vJanela : TitleWindow = new TitleWindow();

	[Bindable]
	public var vJanela1 : TitleWindow = new TitleWindow();
	 
	[Bindable]
	public var pesquisaService:HTTPService;
	 
	[Bindable]
	public var pesquisaQtdService:HTTPService;
	
	 
  	public function abrirNovoDocumento(event:MouseEvent):void {
 	  	 vJanela = new NovoDocumento;
	   	 PopUpManager.addPopUp(vJanela, this, true);
	}
	 
  	public function abrirPesquisa(event:MouseEvent):void {
 	  	 vJanela1 = new Pesquisa;
	   	 PopUpManager.addPopUp(vJanela1, this, true);
	}

		 
	public function init():void{
	 	pesquisaGrid(0,"");
		pesquisaPaginador();	 	
	}
	 
	public function pesquisaGrid(tipo:int,key:String):void{
		pesquisaService = new HTTPService();
		pesquisaService.useProxy = false;
		pesquisaService.method = "GET";
		pesquisaService.showBusyCursor=true;
		 
	 	if (tipo == 0){
			pesquisaService.url = "/documentos/pesquisa";
			pesquisaService.send();
	 	}

	 	if (tipo == 1){
			pesquisaService.url = "/documentos/pesquisaDescricao";
			pesquisaService.send({docdescricao:key});
	 	}	 
	 	
	 	if (tipo == 2){
			pesquisaService.url = "/documentos/pesquisaAutor";
			pesquisaService.send({docautor:key});
	 	}	 

	 	if (tipo == 3){
			pesquisaService.url = "/documentos/pesquisaPalavra";
			pesquisaService.send({palavra:key});
	 	}	 

	 	if (tipo == 4){
			pesquisaService.url = "/documentos/pesquisaArea";
			pesquisaService.send({area_id:key});
	 	}	 
	 		
	 	if (tipo == 5){
			pesquisaService.url = "/documentos/pesquisaTipo";
			pesquisaService.send({tipo_id:key});
	 	}	 	

		pesquisaService.addEventListener(ResultEvent.RESULT,  resultPesquisa);	 		
	 	
    }
    
    public function resultPesquisa(event:Event):void{
		if(pesquisaService.lastResult=="erro_pesquisa"){
			Alert.show("Nenhum registro encontrado para a pesquisa solicitada.");
		}
		 
		if(pesquisaQtdService.lastResult=="erro_pesquisa"){
			Alert.show("Nenhum registro encontrado para a pesquisa solicitada.");
		}     
    }
	 
	public function labelFunctionTipo(row:Object, column:DataGridColumn):String {
        return row.tipo.tipodescricao;
    }

	public function labelFunctionArea(row:Object, column:DataGridColumn):String {
        return row.area.areadescricao;
    }

	public function downloadArquivo():void{
		navigateToURL(new URLRequest("/upload/"+_mainGrid.selectedItem.id+"/"+_mainGrid.selectedItem.docarquivo));
	}	   
	
	public function formataData(item:Object,column:DataGridColumn):String{
  	 //var formatador:DateFormatter = new DateFormatter();
   	 //formatador.formatString= "DD/MM J:NN";
  	 //return formatador.format(item["created-at"]);
  	 var s:String = item["created-at"];
  	 var data:String = s.substr(0,10);
  	 var d:Array = data.split("-",3)
  	 return d[2]+"/"+d[1]+"/"+d[0]+" "+s.substr(11,8)
  	 
    }	
    
    public function pesquisaPaginador():void{
		pesquisaQtdService = new HTTPService();
		pesquisaQtdService.useProxy = false;
		pesquisaQtdService.method = "GET";
		pesquisaQtdService.showBusyCursor=true;
		pesquisaQtdService.url = "/documentos/pesquisaQtd";
		//pesquisaQtdService.send();
		//pesquisaQtdService.addEventListener(ResultEvent.RESULT,  resultPesquisa); 
		var token : AsyncToken = pesquisaQtdService.send();
		token.addResponder(new AsyncResponder(msgResult, msgFault));		  	
		//_txt_paginador.text = pesquisaService.lastResult.toString();
    }
    
	private function msgResult(data:Object, token:Object=null):void{
		trace(data.result);
		_txt_paginador.text = "/ "+data.result;
	}	
	

	private function msgFault(data:Object, token:Object=null):void{
		Alert.show("Houve um erro ao tentar processar os dados no servidor.");
	}		    