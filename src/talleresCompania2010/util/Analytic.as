package talleresCompania2010.util
{
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	
	import flash.display.DisplayObject;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.utils.ObjectUtil;
	
	public class Analytic
	{
		private static var objAnalytic:Analytic;
		
		private const UA:String = Application.application.getUrlServer("UA");
		private const MODE:String = "AS3";
		private const DEBUG:Boolean = Application.application.getUrlServer("debug") == "true" ? true : false;
		
		private var objTraker:AnalyticsTracker;
		
		public function Analytic(){
			try{
				this.objTraker = new GATracker(DisplayObject(Application.application), UA, MODE, DEBUG);
			}catch(e:Error){
				//Ignorada
			}	
		}
		
		public static function getInstance():Analytic{
			if(objAnalytic == null){
				objAnalytic = new Analytic();
			}
			return objAnalytic;
		}
		
		public function trackPageview(pageView:String):void{
			if(Application.application.getUrlServer("enabled") == "true"){
				if(objTraker == null){
					objAnalytic = new Analytic();
				}
				
				try{
					objTraker.trackPageview(pageView);
				}catch(e:Error){
					//Ignorada
				}				
			}			
		}
	}
}