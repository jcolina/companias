package talleresCompania2010.Modulos.Agenda.classes.skins { // Use unnamed package if this skin is not in its own package.

  // Import necessary classes here.
  import flash.display.GradientType;
  import flash.display.Graphics;
  import flash.display.SpreadMethod;
  import flash.geom.Matrix;
  
  import mx.skins.ProgrammaticSkin;

  public class ButtonSkin extends ProgrammaticSkin {

     public var backgroundFillColor:Number;

     // Constructor.
     public function ButtonSkin() {
        // Set default values.
        backgroundFillColor = 0xFFFFFF;
     }

     override protected function updateDisplayList(w:Number, h:Number):void {
        // Depending on the skin's current name, set values for this skin.
        
        switch (name) {
           case "upSkin":
            backgroundFillColor = 0xFFFFFF;
            break;
           case "overSkin":
            backgroundFillColor = 0x7fc4ff;
            break;
           case "downSkin":
            backgroundFillColor = 0x7fc4ff;
            break;
           case "disabledSkin":
            backgroundFillColor = 0xCCCCCC;
            break;
        }

        

        var g:Graphics = graphics;
        g.clear();
        g.beginFill(backgroundFillColor);
        g.drawRect(0, 0, w, h);
        g.endFill();
        
     }
  }
} // Close unnamed package.
