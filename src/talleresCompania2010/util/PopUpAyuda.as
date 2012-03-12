package talleresCompania2010.util
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import talleresCompania2010.Componentes.HtmlPopUp;
	
	
	public class PopUpAyuda
	{
		private static const TITLE:String = "Ayuda";
		private static var htmlViewer:HtmlPopUp;
			
		public static function show():void{
			try{
				htmlViewer = HtmlPopUp(PopUpManager.createPopUp(DisplayObject(Application.application), HtmlPopUp, true));
				htmlViewer.addEventListener(CloseEvent.CLOSE, nullifyPopup);				
				htmlViewer.src = Application.application.getUrlServer("urlSoporte");
				
				htmlViewer.frameWidth = 600;
				htmlViewer.frameHeight = 500;
				htmlViewer.windowTitle = TITLE;
				PopUpManager.centerPopUp(htmlViewer); 		
			}catch(e:Error){
				Alert.show("PopUpAyuda : " + e.message, e.name);
			}
		}
		
		private static function nullifyPopup(event:Event):void{
			htmlViewer = null;
		}
	}
}