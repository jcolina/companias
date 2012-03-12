// ActionScript file

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.DateField;
import mx.core.Application;
import mx.events.CalendarLayoutChangeEvent;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import talleresCompania2010.Modulos.modPrincipal;


	override public function set data(value:Object):void {
		super.data = value;
	//	txFIngreso.text = Object(ArrayCollection(data.detail).getItemAt(0)).FechaIngreso;
		txEstado.text = Object(ArrayCollection(data.detail).getItemAt(0)).Estado;
		txFEntrega.text = Object(ArrayCollection(data.detail).getItemAt(0)).FechaEntrega;
  	}
  	
	private function formatDate(date:String):Date {
		if(date != null){
			return DateField.stringToDate(date, "EEE DD-MM-YYYY");
		}
		return null;
	}
	
	private function updateFEntregaSuccess(event:ResultEvent):void {
  		Application.application.updateGrillaPrincipal();
	}
  