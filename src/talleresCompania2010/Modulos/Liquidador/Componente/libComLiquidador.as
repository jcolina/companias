// ActionScript file
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.events.CloseEvent;
import mx.events.ValidationResultEvent;
import mx.managers.PopUpManager;
import mx.validators.Validator;

import talleresCompania2010.Modulos.Liquidador.Componente.comLiquidador;
import talleresCompania2010.Modulos.Liquidador.Modulos.modLiquidador;
import talleresCompania2010.Modulos.Liquidador.businessLogic.ComLiquidador;
import talleresCompania2010.util.IdiomaApp;

public var aValidators:Array;
public var objIngresoLiquidador:ComLiquidador;
public var objComLiquidador:comLiquidador;
public var ArrayLiquidador:ArrayCollection;
public var listaLiquidador:ArrayCollection;
public var indi:int;
public var Index:int;
public var Accion:String;
public var obmodLiquidador:modLiquidador;
public var id_per:String;
public var personaSeleccionada:Object;

public function initCom():void{
 objIngresoLiquidador = new ComLiquidador(this);	
 objComLiquidador = this;
 ArrayLiquidador = new ArrayCollection();   
	 if(Application.application.Pais == "Chile"){
	 	vlRut.enabled=true;
	 }
	 else {
	 	vlRut.enabled=false;
	 }
 
//Valida la opcion seleccionada por el boton anterior
   if(Accion == modLiquidador.ACCION_UPDATE || Accion == modLiquidador.ACCION_DELETE){
   	 	txRut.text = listaLiquidador[Index].id_persona;
		txNombre.text =listaLiquidador[Index].nombre;
		txApellido.text =listaLiquidador[Index].apellido;
		txCelular.text =listaLiquidador[Index].celular;
		txEmail.text =listaLiquidador[Index].email;
		txFono.text =listaLiquidador[Index].fono;				
 	 }
}

private function createArray():void {
			aValidators = [this.vlNombre, vlApellido, vlEmail, vlCelular, vlRut];	
		}
		
public function ingresaLiquidador(event:MouseEvent):void{	
	var i:int=0;
	var existe:Boolean=false;
	var _arrayValidators:Array;
	indi=0;
	var errors:Array = Validator.validateAll([vlNombre, vlApellido, vlEmail, vlCelular,vlRut]);
	
	if(!errors.length == 0){
		var err:ValidationResultEvent;
		var errorMsg:Array = new Array();
	for each (err in errors) {
		errorMsg.push(err.message);
	}	
	Alert.show(errorMsg.join("\n\n"), IdiomaApp.getText('com_liquidador_datos_invalidos'));
	return;
	}
	else {
		var objNuevoLiquidador:Object = new Object();
			
		objNuevoLiquidador.id_persona=this.txRut.text;
		objNuevoLiquidador.nombre=this.txNombre.text;
		objNuevoLiquidador.apellido=this.txApellido.text;
		objNuevoLiquidador.celular=this.txCelular.text;
		objNuevoLiquidador.email=this.txEmail.text;
		objNuevoLiquidador.fono=this.txFono.text;
		objNuevoLiquidador.cargado="NO";
		objNuevoLiquidador.accion=Accion;
		//si la accion es Insertar Crear Un nuevo Liquidador		
		if(modLiquidador.ACCION_INSERTAR == Accion){
			
			while (i < listaLiquidador.length){
				var liquidador:Object = listaLiquidador.getItemAt(i);			
				if(liquidador.id_persona == this.txRut.text){
		  			existe=true;
		  			//setear el index con el valor del i para marca el objeto
		  			indi=i;
		  			i = listaLiquidador.length.valueOf() + 1;
		  			//Alert.show("Liquidador ya Existe");
		  		}
		  		else{
		  			existe=false;
		  		}					
			 i++;
			}			
		 	if(existe==false){
		 		objNuevoLiquidador.id_per="";
				listaLiquidador.addItem(objNuevoLiquidador);
		 	}
		 	else {
		 		//Alert.show("Liquidador ya Existe");
		 		confirmarModificar();		
		 	}			
		}
		//cierra el POPup	
		Application.application.closePopUp(this);					
	}		
}

public function modificaLiquidador(event:MouseEvent):void{
	var errors:Array = Validator.validateAll([vlNombre, vlApellido, vlEmail, vlCelular,vlRut]);
	var Indice:int;
	var i:int = 0;
	var hay:int=0;
	var existe:Boolean=false;
	if(!errors.length == 0){
		var err:ValidationResultEvent;
		var errorMsg:Array = new Array();
		for each (err in errors) {
			errorMsg.push(err.message);
		}	
		Alert.show(errorMsg.join("\n\n"), IdiomaApp.getText('com_liquidador_datos_invalidos'));
		return;
	}			
			var objNuevoLiquidador:Object = new Object();				
			objNuevoLiquidador.id_persona=this.txRut.text;
			objNuevoLiquidador.nombre=this.txNombre.text;
			objNuevoLiquidador.apellido=this.txApellido.text;
			objNuevoLiquidador.celular=this.txCelular.text;
			objNuevoLiquidador.email=this.txEmail.text;
			objNuevoLiquidador.fono=this.txFono.text;
			objNuevoLiquidador.cargado="NO";
			objNuevoLiquidador.accion=Accion;
			//si la accion es update, modifica los datos
			if(modLiquidador.ACCION_UPDATE == Accion){				
						while (i < listaLiquidador.length){
						var liquidador:Object = listaLiquidador.getItemAt(i);			
						if((liquidador.id_persona == this.txRut.text && personaSeleccionada.id_per == liquidador.id_per) ){
				  			//existe=true;
				  			hay=0;
				  		  	i = listaLiquidador.length.valueOf() + 1;
				  		}
				  		else{
				  			//existe=false;
				  			hay+=1;
				  		}					
						 i++;
						}					
				if(hay == 0){
					objNuevoLiquidador.id_per=listaLiquidador[Index].id_per;
					if(objNuevoLiquidador.id_per == ""){
					   objNuevoLiquidador.accion="IN";
					}
					else {
					   objNuevoLiquidador.accion="UP";
					}				
					listaLiquidador.removeItemAt(Index);
					listaLiquidador.addItemAt(objNuevoLiquidador,Index);					
				}
				else {
					Alert.show(IdiomaApp.getText('com_liquidador_ya_existe'),IdiomaApp.getText('com_liquidador_title_error'));			
				}				
			}
			Application.application.closePopUp(this);	
}

public function CierraPop():void{
	PopUpManager.removePopUp(this);
}

public function confirmarModificar():void
{
	  Alert.buttonWidth = 100;
	  Alert.noLabel = IdiomaApp.getText('general_cancelar');
	  Alert.yesLabel = IdiomaApp.getText('general_aceptar');
	  Alert.show(IdiomaApp.getText('com_liquidador_ya_ingresado'),IdiomaApp.getText('com_liquidador_confirma'),Alert.YES|Alert.NO,null,aceptar,null,Alert.NO);
}
		
public function aceptar(event:CloseEvent):void {
	if (event.detail==Alert.YES){
		
		var objNuevoLiquidador:Object = new Object();			
		objNuevoLiquidador.id_persona=this.txRut.text;
		objNuevoLiquidador.nombre=this.txNombre.text;
		objNuevoLiquidador.apellido=this.txApellido.text;
		objNuevoLiquidador.celular=this.txCelular.text;
		objNuevoLiquidador.email=this.txEmail.text;
		objNuevoLiquidador.fono=this.txFono.text;
		objNuevoLiquidador.cargado="NO";
		objNuevoLiquidador.accion="UP";				
		objNuevoLiquidador.id_per=listaLiquidador[indi].id_per;
		listaLiquidador.removeItemAt(indi);
		listaLiquidador.addItemAt(objNuevoLiquidador,indi);
		Alert.show(IdiomaApp.getText('com_liquidador_registro_modificado'),IdiomaApp.getText('com_liquidador_registro_title_mod'));
		}
	else if(event.detail==Alert.NO){			
		
		Alert.show(IdiomaApp.getText('com_liquidador_registro_cancelado'),IdiomaApp.getText('com_liquidador_registro_title_mod')); 
		CierraPop();

	}
} 
public function llenaCampos():void{	
	var i:int=0;
	var exist:Boolean;
	var ini:int;
	while (i < listaLiquidador.length){
				var liquidador:Object = listaLiquidador.getItemAt(i);			
				if(liquidador.id_persona == this.txRut.text){
					txNombre.text=liquidador.nombre;
					txApellido.text=liquidador.apellido;
					txCelular.text=liquidador.celular;
					txEmail.text=liquidador.email;
					txFono.text=liquidador.fono;
					i = listaLiquidador.length.valueOf() + 1;
		  		}
		  		else{
		  			exist=false;
		  		}					
			 i++;
			}		
	txNombre.text =listaLiquidador[Index].nombre;
	txApellido.text =listaLiquidador[Index].apellido;
	txCelular.text =listaLiquidador[Index].celular;
	txEmail.text =listaLiquidador[Index].email;
	txFono.text =listaLiquidador[Index].fono;	
}