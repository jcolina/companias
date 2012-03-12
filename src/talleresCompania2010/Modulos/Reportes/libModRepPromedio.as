// ActionScript file
import mx.charts.events.ChartItemEvent;
import mx.controls.Alert;
import mx.core.Application;

import talleresCompania2010.Modulos.Reportes.grafPromedio;
import talleresCompania2010.util.ImageChartExport;

import talleresCompania2010.util.IdiomaApp;

public var graficoProm:grafPromedio;

public function initMod():void{
	//Application.application.objBotonPopUp = popUpLeyenda;
	this.canvasInit();
	graficoProm = new grafPromedio(this);
}

// Hack to prevent propagation of the ChartItemEvent.CHANGE as it is in conflict with IndexChangedEvent.CHANGE
private function canvasInit(): void{
	this.addEventListener(ChartItemEvent.CHANGE, chartItemEventChange, true, 0, true);
}

private function chartItemEventChange(event: Event): void{
	event.stopImmediatePropagation();
}

private function excel():void{
	graficoProm.graficoExcel();
}

private function graficoToImage():void{
	if(myChart.dataProvider != null){
		var date:String = Application.application.getSerialFecha();
		ImageChartExport.export(myChart, chartContainer, IdiomaApp.getText('lib_mod_rep_promedio_prom') + date + ".png");
	}else{
		Alert.show(IdiomaApp.getText('lib_mod_rep_ranking2_alert_contener'), IdiomaApp.getText('general_aviso_title'));
	}
}

