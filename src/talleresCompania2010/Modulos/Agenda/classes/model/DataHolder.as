package talleresCompania2010.Modulos.Agenda.classes.model
{
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	import talleresCompania2010.Modulos.Agenda.classes.events.CustomEvents;
	
	/**
	 * DataHolder class represent all data which needs to be stored 
	 * or needs to be used by any of the classes.
	 * It also dispatches events on adding a new event from any of the views.
	 * It is a singletone class so only single instance will be created through out the application cycle.
	*/
	public class DataHolder extends EventDispatcher 
	{
		import flash.events.EventDispatcher;
		
		public static var objDataHolder:DataHolder;
		
		private var m_arrEvents:ArrayCollection; 
		
		public function DataHolder()
		{
			m_arrEvents = new ArrayCollection();
		}
		
		// return class instance and if it is not created then create it first and the return.
		public static function getInstance():DataHolder
		{
			if(objDataHolder == null)
			{
				objDataHolder = new DataHolder;
			}
			
			return objDataHolder;
		}
		
		// will add any event. used by day view and week view to do so.
		public function addEvent(_obj:Object):void
		{
			m_arrEvents.addItem(_obj);
			updateViews();
		}
		
		// dispatch event to main.mxml to update views as per new event added
		public function updateViews():void
		{
			dispatchEvent(new CustomEvents(CustomEvents.ADD_NEW_EVENT));
		}
		
		// currently not being used but could be used when we need to add a functionality of removing an event
		public function removeEventAt(index:int):void
		{
			//m_arrEvents.splice(index, 1);
		}
		
		// set and get dataprovider, which store all event related data
		public function set dataProvider(_arrEvents:ArrayCollection):void
		{
			m_arrEvents = _arrEvents;
		}
		
		public function get dataProvider():ArrayCollection
		{
			return m_arrEvents;
		}
		
		public function buscarDatos(fecha:String):Object
		{
			var encontrado:Boolean = false;
			
			for(var i:int = 0; i < m_arrEvents.length; i++){
					if(m_arrEvents[i].fecha.toString() == fecha){
						encontrado = true;
				}
			}
			return encontrado;
		}
		
		public function getDatos(fecha:String):Object
		{
			var objDatos:Object = new Object();			
			for(var i:int = 0; i < m_arrEvents.length; i++){				
				if(m_arrEvents[i].fecha == fecha){
					objDatos = m_arrEvents[i];
				}
			}
			return objDatos;
		}
	}
}