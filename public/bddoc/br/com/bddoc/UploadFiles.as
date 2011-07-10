package br.com.bddoc.utils {
// ActionScript file
   import flash.net.FileReference;
   import flash.net.URLRequestHeader;
   import flash.net.URLRequest;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.events.IOErrorEvent;
   import mx.controls.Alert;
   import br.com.bddoc.novoDocumento;
  
 
   public class UploadFiles{
	   private var uploadFileRefList:FileReference = new FileReference();
	   private var uploadURLReq:URLRequest;
	   private var URLString:String="/documentos/upload";  //Nome do controler/action
	   private  var nameFile:String;

	   
	   
	   public function getNameFile():String{
	   	  return nameFile;
	   }

	   public function uploadFiles():void
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

	   	   nameFile = uploadFileRefList.name;
	       //doUpload(uploadFileRefList);	       
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
	       Alert.show(Math.floor((event.bytesLoaded/event.bytesTotal)*100) + "% complete");
	   }
	   
	   private function uploadIoErrorHandler (event:Event):void
	   {
	       trace("Upload failed: " + event);
	       Alert.show("Upload failed: " + event);
	   }
	   
	   private function uploadCompleteHandler (event:Event):void
	   {
	       //upload_btn.enabled=true;
	       trace("Upload successfull: ");
	       Alert.show("Upload successfull: ");
	   }   
   
   }
   
}