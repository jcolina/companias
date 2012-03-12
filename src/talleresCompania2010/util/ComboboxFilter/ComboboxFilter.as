package talleresCompania2010.util.ComboboxFilter
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.TitleWindow;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.controls.DataGrid;
	import mx.controls.LinkButton;
	import mx.controls.TextInput;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.Application;
	import mx.effects.WipeDown;
	import mx.events.CloseEvent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	import mx.utils.ObjectUtil;
	
	import talleresCompania2010.util.IdiomaApp;
	
	public class ComboboxFilter extends LinkButton
	{
		/**
		 * 
		 * Variables
		 * 
		 */
		 
		 /**
		 * Privadas
		 */
		 
		[Embed(source='assets/find.png')]
		private const DEFAULT_ICON:Class;
		
		private const DEFAULT_TOOLTIP:String = IdiomaApp.getText("combobox_filter_default_tooltip");
		
		private var _combobox:ComboBox;
		
		private var titleWindows:* = null;
		private var text:TextInput;
		private var dataGrid:DataGrid;
		//private var titleWindows:TitleWindow = null;
		
		 /**
		 * Públicas
		 */
		
		public function set combobox(_combobox:ComboBox):void{
			this._combobox = _combobox;
		}
		
		public function get combobox():ComboBox{
			return this._combobox;
		}
		
		/*
		 * Estas variables indican la posicion del filtro
		 
		 si se pone false, hará lo contrario al nombre
		 
		 ejemplo, si pongo showDerecha = false, lo desplegara a la izquierda
		 */
		 
		public var showDerecha:Boolean = true;
		public var showArriba:Boolean = true;
		
		/**
		 * Constructor
		 */
		public function ComboboxFilter()
		{
			super();
			
			this.width = 15;
			this.addChild(new DEFAULT_ICON());
			
			if(toolTip == null || toolTip == ""){
				this.toolTip = DEFAULT_TOOLTIP;
			}
			
			this.addEventListener(MouseEvent.CLICK, onClickListener);
		}
		
		private function onClickListener(event:MouseEvent):void{
			if(validarCombobox()){
				if(titleWindows == null){
					titleWindows = PopUpManager.createPopUp(DisplayObject(Application.application), TitleWindow);
					setTitleWindowsProperties(event);
				}else{
					onCloseTitleWindows();
				}				
			}			
		}
		
		private function setTitleWindowsProperties(event:MouseEvent):void{
			titleWindows.title = IdiomaApp.getText("combobox_filter_default_title_window");
			titleWindows.layout = "absolute";
			titleWindows.showCloseButton = true;
			
			titleWindows.width = 190;
			titleWindows.height = 235;
			
			var showEffect:WipeDown = new WipeDown();
			showEffect.duration = 400;
			showEffect.target = titleWindows;
			showEffect.play();
			
			var vbox:VBox = new VBox();
			vbox.setStyle("top", 5);
			vbox.setStyle("left", 5);
			vbox.setStyle("right", 5);
			vbox.setStyle("bottom", 5);
			
			
			text = new TextInput();
			text.addEventListener(Event.CHANGE, onTextChange);
						
			var column:DataGridColumn = new DataGridColumn();
			column.dataField = combobox.labelField;
			column.headerText = "";
			
			dataGrid = new DataGrid();
			dataGrid.columns = [column];
			dataGrid.percentWidth = 100;
			dataGrid.dataProvider = new ArrayCollection(ObjectUtil.copy(combobox.dataProvider.source) as Array);
			dataGrid.doubleClickEnabled = true;
			dataGrid.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClickDataGrid);			
			
			vbox.addChild(text);
			vbox.addChild(dataGrid);
			
			titleWindows.addChild(vbox);
			
			var xPosition:Number = event.stageX + 10;
			var yPosition:Number = event.stageY;
			
			if(!showArriba){
				yPosition = yPosition - titleWindows.height;
			}
			
			if(!showDerecha){
				xPosition = xPosition - titleWindows.width - 10;
			}
			
			titleWindows.x = xPosition;
			titleWindows.y = yPosition;
			
			titleWindows.addEventListener(CloseEvent.CLOSE, onCloseTitleWindows);

		}
		
		private function onDoubleClickDataGrid(event:MouseEvent):void{
			if(event.currentTarget.selectedItem != null){
				posicionarCombobox(event.currentTarget.selectedItem[combobox.labelField]);
				onCloseTitleWindows();
			}
		}
		
		private function posicionarCombobox(key:String):void{
		  	var sDataValueCur:String = "";
	  		for(var i:int = 0; i < combobox.dataProvider.length; i++ ){
		   	 	if(combobox.dataProvider[i][combobox.labelField] == key){
		   	 		var lastValue:String = "";
		   	 		try{
		   	 			lastValue = combobox.selectedItem[combobox.labelField];
		   	 		}catch(e:Error){
		   	 			//Ignorada por si no hay nada cargado
		   	 		}
		   	 		combobox.selectedIndex = i;
		   	 		if(lastValue != key){
		   	 			combobox.dispatchEvent(new ListEvent(ListEvent.CHANGE));
		   	 		}		   	 		
		   	 		return;
		   	 	}
	  		}	  	
  		}
		
		
		private function onTextChange(event:Event):void{
			if (this.text.text != "") {
				dataGrid.dataProvider.filterFunction = processFilter;
		    } else {
		        dataGrid.dataProvider.filterFunction = null;
		    }
		    
		    dataGrid.dataProvider.refresh();
		}
		
		
		private function processFilter(item:Object):Boolean {
			try{
				return item[combobox.labelField].toString().toUpperCase().indexOf(text.text.toUpperCase()) != -1;
			} catch(e:Error){
				//Ignorado
			}	
		    return false;
		}
		
		
		
		private function onCloseTitleWindows(event:CloseEvent = null):void{
			if(titleWindows != null){
				PopUpManager.removePopUp(titleWindows);
				titleWindows = null;
			}
		}
		
		private function validarCombobox():Boolean{
			if(combobox == null){
				Alert.show(IdiomaApp.getText("combobox_filter_validate_combobox_null"), IdiomaApp.getText("general_alert_title"));
				return false;
			}
			
			if(combobox.dataProvider.length < 1){
				Alert.show(IdiomaApp.getText("combobox_filter_validate_combobox_no_data"), IdiomaApp.getText("general_alert_title"));
				return false;
			}
			
			return true;
		}

	}
}