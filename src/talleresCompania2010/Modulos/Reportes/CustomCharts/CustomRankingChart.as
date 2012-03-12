package talleresCompania2010.Modulos.Reportes.CustomCharts{ // Empty package.
  
  import mx.charts.series.items.ColumnSeriesItem;
  import mx.skins.ProgrammaticSkin;
  import mx.core.IDataRenderer;
  import flash.display.Graphics;
  
  public class CustomRankingChart extends mx.skins.ProgrammaticSkin 
     implements IDataRenderer {
     
     //private var colors:Array = [0xCCCC99,0x999933,0x999966];
     private var colors:Array = [0xf7ce2c,0xefce4a,0xefe14a, 0xefed4a, 0xebf191, 0xa19c9c, 0xafaaaa, 0xbcb6b6, 0xc9c2c2, 0xd5cdcd];
     private var _chartItem:ColumnSeriesItem;
     
     public function CustomRankingChart() {
        // Empty constructor.
     }
     
     public function get data():Object {
        return _chartItem;
     }

     public function set data(value:Object):void {
        _chartItem = value as ColumnSeriesItem; 
        invalidateDisplayList();
     }

     override protected function
        updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void {
           super.updateDisplayList(unscaledWidth, unscaledHeight);
           var g:Graphics = graphics;
           g.clear();  
           g.beginFill(colors[(_chartItem == null)? 0:_chartItem.index]);
           g.drawRect(0, 0, unscaledWidth, unscaledHeight);
           g.endFill();
     }
  } // Close class.
} // Close package.

