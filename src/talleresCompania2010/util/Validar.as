package talleresCompania2010.util{
	import mx.controls.Alert;
	import mx.events.ValidationResultEvent;
	import mx.validators.Validator;
	
	public class Validar{
		public function Validar(){
		
		}

		public function validarCampos(arrayCamposVali:Array, titleMsg:String):Boolean{
			try {
				var bValidar:Boolean= false;
				var errors:Array = Validator.validateAll(arrayCamposVali);
				if(!errors.length == 0){
					var err:ValidationResultEvent;
					var errorMsg:Array = new Array();
					for each (err in errors) {
						errorMsg.push(Object(err.currentTarget.source).name +": " + err.message);
					}
					Alert.show(errorMsg.join("\n\n"), titleMsg);
					bValidar = false;
				}else{
					bValidar = true;
				}
			}catch(e:Error){
				Alert.show("Error al Validar los campos obligatorios :" + e.message, "Aviso");
			}	
			return bValidar;			
		}

	}
}