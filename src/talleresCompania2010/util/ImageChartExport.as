package talleresCompania2010.util
{
	import flash.net.FileReference;
	
	import mx.containers.Canvas;
	import mx.formatters.SwitchSymbolFormatter;
	import mx.graphics.ImageSnapshot;
	import mx.graphics.codec.PNGEncoder;
	
	public class ImageChartExport
	{
	
		public static function export(chart:*, container:Canvas, fileName:String = "Imagen Gráfico.png"):void{
			var preFont:int = chart.getStyle("fontSize");
			
			container.height = chart.height;
			container.width = chart.width;
			
			chart.setStyle("fontSize", getFontSize(chart.dataProvider.length));
			chart.validateNow();
			
			var image:ImageSnapshot = ImageSnapshot.captureImage(chart, 0, new PNGEncoder());
            
            container.percentHeight = 100;
			container.percentWidth = 100;
			
			chart.setStyle("fontSize", preFont);			
			
			var file:FileReference = new FileReference();
			file.save(image.data, fileName);
		}
		
		private static function getFontSize(size:int):int{
						
			if(size > 149){
				return 80;
			}
			
			if(size > 79){
				return 60;
			}
			
			if(size > 49){
				return 45;
			}
			
			if(size > 19){
				return 30;
			}
			
			return 12;
		}
	}
}