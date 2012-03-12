// ActionScript file
import org.bytearray.gif.player.GIFPlayer;

public var patente:String;
public var siniestro:String;

private function initCom():void{
	this.lblVehiculo.text = "Bucando datos del vehículo " + patente + ", siniestro " + siniestro + "\n\nEspere un momento porfavor";
	var myGIFPlayer:GIFPlayer = new GIFPlayer();
	container.addChild(myGIFPlayer);
	myGIFPlayer.load(new URLRequest("assets/wait.gif"));
}
