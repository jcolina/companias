package talleresCompania2010.util.ADG
{
	import mx.controls.advancedDataGridClasses.AdvancedDataGridGroupItemRenderer;
	
	[Style (name="rowColor", type="unit", format="Color", inherit="yes")]
	
	public class GroupItemRenderCustom extends AdvancedDataGridGroupItemRenderer
	{
		
/* 		private static var stylesInited:Boolean = initStyles();

 		private static function initStyles():Boolean {
			HaloDefaults.init();
	
			var ADGItemRenderCustomStyle:CSSStyleDeclaration =
				HaloDefaults.createSelector("ADGItemRenderCustom");
	
			ADGItemRenderCustomStyle.defaultFactory = function():void
			{
				this.rowColor = 0xACFA58;
			}
	
			return true;
		} */
		
		
		public function GroupItemRenderCustom(){
			super();
//			label.background = true;
		}
		
		override public function validateNow():void{
			if(getStyle("rowColor") == null){
				label.background = false;
				super.validateNow();
			}else{
				label.background = true;
				label.backgroundColor = getStyle("rowColor");
//				trace(backgroundColor + " *** " + getStyle("rowColor") + " *** " + background);
				super.validateNow();
			}
		}
		
	}
}