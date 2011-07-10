package br.com.bddoc.utils {
	import mx.validators.Validator;
	import mx.validators.ValidationResult;
	
	public class ServerErrors {
		public static var BASE:String = ":base";
		/**
		* Os erros estão em campos específicos(Onde a base é BASE).
	    * As chaves são os campos String; Os valores ficam em um Array de erros.
		*/
		private var _allErrors:Object;
		
		public function ServerErrors(errorsXML:XML) {
			_allErrors = {};
			for each (var error:XML in errorsXML.error) {
			 var field:String = error.@field;
			 if (field == null || field == "") {
				 field = BASE;
			 }
			 if (_allErrors[field] == null) {
				 _allErrors[field] = [error.@message];
			 } else {
				 var fieldErrors:Array = _allErrors[field];
				 fieldErrors.push(error.@message);
			 }
			}
		}
		/**
		 * Retorna os erros para cada campo, ou uma disposição vazia caso não exista um erro
		*/
		public function getErrorsForField(field:String):Array {
			return _allErrors[field] == null ? [] : _allErrors[field];
		}
	}
}	