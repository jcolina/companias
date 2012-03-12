package talleresCompania2010.util.ADG
{
	import mx.charts.styles.HaloDefaults;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridItemRenderer;
	import mx.styles.CSSStyleDeclaration;
	
	[Style (name="rowColor", type="unit", format="Color", inherit="yes")]
	
	public class ADGItemRenderCustom extends AdvancedDataGridItemRenderer
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
		
		
		public function ADGItemRenderCustom(){
			super();
			background = true;
		}
		
		override public function validateNow():void{
			if(getStyle("rowColor") == null){
				background = false;
				super.validateNow();
			}else{
				background = true;
				backgroundColor = getStyle("rowColor");
//				trace(backgroundColor + " *** " + getStyle("rowColor") + " *** " + background);
				super.validateNow();
			}
		}
		
	}
}