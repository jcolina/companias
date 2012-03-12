// ActionScript file
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.core.Application;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.mxml.HTTPService;

import talleresCompania2010.Modulos.Documentos.Componentes.VisorImagenes.Views.comImage;
import talleresCompania2010.util.IdiomaApp;

[Embed(source='assets/left_green.png')]
private const GREEN_LEFT_ICON:Class;

[Embed(source='assets/left_blue.png')]
private const RED_LEFT_ICON:Class;

[Embed(source='assets/right_green.png')]
private const GREEN_RIGHT_ICON:Class;

[Embed(source='assets/right_blue.png')]
private const RED_RIGHT_ICON:Class;


[Bindable]
private var objRightIcon:Object = GREEN_RIGHT_ICON;

[Bindable]
private var objLeftIcon:Object = GREEN_LEFT_ICON;

//private const datos:Array = ["Jellyfish.jpg", "Koala.jpg", "Jellyfish.jpg", "Jellyfish.jpg", "Koala.jpg", "Koala.jpg", "Koala.jpg", "Koala.jpg"];
//private const datos:Array = ["Jellyfish.jpg", "Koala.jpg", "Jellyfish.jpg", "Jellyfish.jpg", "Jellyfish.jpg", "Jellyfish.jpg"];
private var index:int;
private var datos:ArrayCollection;

private function initMod():void{
	if(Application.application.ObjVehiculo != null) {		
		solListaImagenes();
	}else{
		Application.application.objComVisorImagen.viewPrincipal.selectedChild = Application.application.objComVisorImagen.viewDefault;
	}
}

private function solListaImagenes():void{
	var urlServer:String = Application.application.getUrlServiceAlfresco("alfrescoListDocument") + "/vid=";
	var IDVehiculo:String = Application.application.ObjVehiculo.IDVehiculo;
	var ticket:String = Application.application.ticket;	
	var objHttpService:HTTPService = new HTTPService();
	objHttpService.method = "POST";
	objHttpService.showBusyCursor = true;
	objHttpService.url = urlServer + IDVehiculo + "&filter=Fotos?format=atom&alf_ticket=" + ticket;
	objHttpService.send();
	objHttpService.addEventListener(ResultEvent.RESULT, cargaVisor);
	objHttpService.addEventListener(FaultEvent.FAULT, function(event:FaultEvent):void{});
}

private function cargaVisor(event:ResultEvent):void {
	datos = new ArrayCollection();
	var objTemp:Object;
	
	if(event.result.L != null){
		if(!event.result.L.R.hasOwnProperty("list")){
			event.result.L.R.link +="?alf_ticket=" + Application.application.ticket;
			objTemp = new Object();
			objTemp.link = event.result.L.R.link;
			objTemp.titulo = event.result.L.R.title;
			objTemp.etapa = event.result.L.R.etapa;
			datos.addItem(objTemp);
		}else{
			for(var i:int = 0 ; i < event.result.L.R.length;i++){
				event.result.L.R[i].link+="?alf_ticket=" + Application.application.ticket;
				objTemp = new Object();
				objTemp.link = event.result.L.R[i].link;
				objTemp.titulo = event.result.L.R[i].titulo;
				objTemp.etapa = event.result.L.R[i].etapa;
				datos.addItem(objTemp);
			}
		}
		updateData();
	}else{
		Application.application.objComVisorImagen.viewPrincipal.selectedChild = Application.application.objComVisorImagen.viewSinImagen;
	}
}

private function updateData():void{
	for(var i:int = 0; i < datos.length; i++){
		var objComImage:comImage = new comImage();
		cnvContainer.addChild(objComImage);
		objComImage.imgFuente.source = datos[i].link;
		objComImage.imgFuente.toolTip = IdiomaApp.getText('mod_lista_documento_etapa')+" " + datos[i].etapa;
		objComImage.imgFuente.addEventListener(MouseEvent.CLICK, onClick);
		/*
		if(datos.length < 7){
			objComImage.percentHeight = 100;
		}
		*/
	}
	Application.application.objComVisorImagen.viewPrincipal.selectedChild = Application.application.objComVisorImagen.viewImagen;
	imgPrincipal.source = datos[index].link;
}

private function nextImage():void{
	index++;
	if(index > datos.length - 1){
		index = 0;
	}
	setIndex(index);
}

private function lastImage():void{
	index--;
	if(index < 0){
		index = datos.length - 1;
	}
	setIndex(index);
}

private function setIndex(index:int):void{
	imgPrincipal.visible = false;
	imgPrincipal.source = datos[index].link;
	imgPrincipal.visible = true;
}

private function searchIndex(source:String):int{
	for(var i:int = 0; i < datos.length; i++){
		if(datos[i].link == source){
			index = i;
			return i;
		}
	}
	return -1;
}

private function onClick(event:MouseEvent):void{
	setIndex(searchIndex(event.currentTarget.source));
}

private function onMouseOver(event:MouseEvent):void{
	if(event.currentTarget.id == "lnkLast"){
		objLeftIcon = RED_LEFT_ICON;
	}else{
		objRightIcon = RED_RIGHT_ICON;
	}
}

private function onMouseOut(event:MouseEvent):void{
	if(event.currentTarget.id == "lnkLast"){
		objLeftIcon = GREEN_LEFT_ICON;
	}else{
		objRightIcon = GREEN_RIGHT_ICON;
	}
}


private function onClickImage():void{
	Application.application.openBrowser(imgPrincipal.source, "_blanck");
}
