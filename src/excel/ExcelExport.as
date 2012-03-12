package excel
{
import com.as3xls.xls.ExcelFile;
import com.as3xls.xls.Sheet;

import flash.errors.IllegalOperationError;
import flash.net.FileReference;
import flash.utils.ByteArray;

import mx.charts.chartClasses.ChartBase;
import mx.collections.ArrayCollection;
import mx.collections.ICollectionView;
import mx.collections.IViewCursor;
import mx.collections.XMLListCollection;
import mx.controls.AdvancedDataGrid;
import mx.controls.DataGrid;
import mx.controls.OLAPDataGrid; 
 
    
 
   /** 
 
    * 
 
    * Author: Andrés Lozada Mosto 
 
    * Version: 0.5 
 
    * Fecha release: 25/03/2009 
 
    * Contacto: alfathenus@gmail.com 
 
    *   
 
    * Clase que maneja la exportacion de elementos 
 
    * a Excel. 
 
    *  
 
    * Se utiliza el proyecto http://code.google.com/p/as3xls/  
 
    * para la generacion de Excel. 
 
    *  
 
    * Se necesita la version 10 de Flash player para realizar el correcto 
 
    * guardado del archivo sin pasar por backend. 
 
    *  
 
    * @example 
 
    * <code> 
 
    * private var flat:ArrayCollection = new ArrayCollection([ 
 
    *                              {nombre:"Andrés", apellido:"Sanchez"}, 
 
    *                              {nombre:"Mónica", apellido:"Sanchez"}, 
 
    *                              {nombre:"Agustina", apellido:"Sanchez"}, 
 
    *                              {nombre:"Pablo", apellido:"Sanchez"}, 
 
    *                              {nombre:"Magalí", apellido:"Sanchez"} 
 
    *                              ]); 
 
    * //Exportando desde un datagrid 
 
    * ExcelExport.fromGrid(this.dg, "prueba_excel_datagrid.xls"); 
 
    * //Exportacion general (en este caso un chart) 
 
    * ExcelExport.export(this.Areachart, "prueba_excel_chart.xls", {colsValues:[{header:"Month", value:"Month"}]}) 
 
    * </code> 
 
    *  
 
    * Lista de funciones 
 
    * <list> 
 
    *  fromGrid:          Exporta un datagrid a un excel de forma automática 
 
    *  fromChart:         Exporta un gráfico a un excel de forma automática 
 
    *  fromObject:       Exporta un listado de objetos XML, XMLList, Array o ICollectionView 
 
    *  export:            Exporta los datos q se le pasen delegando a la tarea a la funcion 
 
    *                   correspondiente dependiendo el proveedor de datos 
 
    * </list> 
 
    *  
 
    */ 
 
     
 
   public class ExcelExport 
 
   { 
 
      public function ExcelExport() 
 
      { 
 
         throw new IllegalOperationError("Class \"ExcelExporterUtil\" is static. You can't instance this"); 
 
      } 
 
       
 
      //----------------------------- 
 
      // Public function 
 
      //----------------------------- 
 
      /** 
 
       *  
 
       * Exporta los datos de un datagrid hacia un Excel. 
 
       * Toma el dataProvider del mismo y las columnas para su exportación. 
 
       *  
 
       * @param grid                Referencia al DataGrid, AdvancedDataGrid u OLAPDataGrid 
 
       * @param defaultName         Nombre default con el q se va a generar el archivo excel 
 
       * @param params            Parámetros opcionales 
 
       *                         { 
 
       *                            extraDataBefore:Listado de columnas extras (a colocar antes de las columnas del datagrid)  
 
       *                                        a las columnas del datagrid. Su dato se encuentra en el dataprovider  
 
       *                                        del datagrid. 
 
       *                                        Formato: 
 
       *                                        [{header:"nombre del header", value:"propiedad del objeto que contiene el valor"}] 
 
       *                            extraDataAfter:Listado de columnas extras (a colocar luego de las columnas del datagrid) 
 
       *                                        a las columnas del datagrid. Su dato se encuentra en el dataprovider  
 
       *                                        del datagrid. 
 
       *                                        Formato: 
 
       *                                        [{header:"nombre del header", value:"propiedad del objeto que contiene el valor"}] 
 
       *                         } 
 
       *  
 
       */ 
 
      static public function fromGrid(grid:*, defaultName:String, params:Object):void  
 
      { 
 
         if ( !(grid is DataGrid) && !(grid is AdvancedDataGrid) && !(grid is OLAPDataGrid) ) 
 
            return; 
 
          
 
         if (grid == null || grid.dataProvider == null || defaultName == null || defaultName == "") 
 
            throw new ArgumentError("ExcelExporterUtil.datagridToExcel. Error in arguments"); 
 
          
 
         var colsValues2:Array = (params.hasOwnProperty("colsValues"))?params.colsValues:[]; 
 
         var extraSeriesBefore:Array = (params.hasOwnProperty("extraDataBefore"))?params.extraDataBefore:[]; 
 
         if ( extraSeriesBefore.length > 0 && colsValues2.length > 0 ) 
 
            extraSeriesBefore = extraSeriesAfter.concat(colsValues2); 
 
         else if (extraSeriesBefore.length == 0 && colsValues2.length > 0 ) 
 
            extraSeriesBefore = colsValues2; 
 
         var extraSeriesAfter:Array = (params.hasOwnProperty("extraDataAfter"))?params.extraDataAfter:[]; 
 
          
 
         var colsValues:Array = ExcelExport.generateColsValues( 
 
                                                   grid.columns,  
 
                                                   "headerText",  
 
                                                   "dataField",  
 
                                                   extraSeriesBefore,  
 
                                                   extraSeriesAfter 
 
                                                   ); 
 
 
 
         if ( colsValues.length == 0 ) 
 
            return; 
 
             
 
         ExcelExport.fromObject(grid.dataProvider, defaultName, {colsValues:colsValues}); 
 
      } 
 
       
 
      /** 
 
       *  
 
       * Exporta los datos de un gráfico de flex hacia un Excel. 
 
       * Toma el dataProvider del mismo y las series para su exportación. 
 
       *  
 
       * @param chart                Referencia al datagrid 
 
       * @param defaultName         Nombre default con el q se va a generar el archivo excel 
 
       * @param params            Parámetros opcionales 
 
       *                         { 
 
       *                            extraDataBefore:Listado de series extras (a colocar antes de las series del chart)  
 
       *                                        a las series del chart. Su dato se encuentra en el dataprovider  
 
       *                                        del datagrid. 
 
       *                                        Formato: 
 
       *                                        [{header:"nombre del header", value:"propiedad del objeto que contiene el valor"}] 
 
       *                            extraDataAfter:Listado de series extras (a colocar luego de las series del chart) 
 
       *                                        a las series del chart. Su dato se encuentra en el dataprovider  
 
       *                                        del chart. 
 
       *                                        Formato: 
 
       *                                        [{header:"nombre del header", value:"propiedad del objeto que contiene el valor"}] 
 
       *                         } 
 
       *  
 
       */ 
 
      static public function fromChart(chart:ChartBase, defaultName:String, params:Object):void 
 
      { 
 
         if ( chart == null || chart.dataProvider == null || chart.dataProvider.length < 1 ||  
 
            chart.series == null || chart.series.length < 1 ||  
 
            defaultName == null || defaultName == "" ) 
 
            throw new ArgumentError("ExcelExporterUtil.graphToExcel. Error in arguments"); 
 
          
 
         var colsValues2:Array = (params.hasOwnProperty("colsValues"))?params.colsValues:[]; 
 
         var extraColumsBefore:Array = (params.hasOwnProperty("extraDataBefore"))?params.extraDataBefore:[]; 
 
         if ( extraColumsBefore.length > 0 && colsValues2.length > 0 ) 
 
            extraColumsBefore = extraColumsBefore.concat(colsValues2); 
 
         else if (extraColumsBefore.length == 0 && colsValues2.length > 0 ) 
 
            extraColumsBefore = colsValues2; 
 
         var extraColumnsAfter:Array = (params.hasOwnProperty("extraDataAfter"))?params.extraDataAfter:[]; 
 
          
 
         var colsValues:Array = ExcelExport.generateColsValues( 
 
                                                chart.series,  
 
                                                "displayName",  
 
                                                "yField",  
 
                                                extraColumsBefore,  
 
                                                extraColumnsAfter); 
 
         if ( colsValues.length == 0 ) 
 
            return; 
 
             
 
         ExcelExport.fromObject(chart.dataProvider, defaultName, {colsValues:colsValues}); 
 
      } 
 
       
 
      /** 
 
       *  
 
       * Export to Excell 
 
       *  
 
       * @param obj          Objeto simple, XML, XMLList, Array, ArrayCollection o XMLListCollection 
 
       *                   que se quiere exportar a excel 
 
       * @param defaultName   Nombre default con el que se genera el excel exportToFile 
 
       * @param params      Listado de objetos que indican cual es el nombre de la columna 
 
       *                   y que propiedad del objeto se utiliza para sacar los datos de la columna 
 
       *                   {header:"nombre del header", value:"propiedad del objeto que contiene el valor"} 
 
       *  
 
       */ 
 
      static public function fromObject(obj:Object, defaultName:String, params:Object):void 
 
      { 
 
         if ( !(obj is XML) && !(obj is XMLList) && !(obj is XMLList) && !(obj is Array) && !(obj is ICollectionView) ) 
 
            return; 
 
          
 
         var colsValues:Array = (params.hasOwnProperty("colsValues"))?params.colsValues:null; 
 
          
 
         if ( colsValues == null || colsValues.length == 0 ) 
 
            return; 
 
          
 
         var _dp:ICollectionView = ExcelExport.getDataProviderCollection(obj); 
 
         if ( _dp == null ) 
 
            return; 
 
             
 
         ExcelExport.exportToExcel(_dp, colsValues, defaultName); 
 
      } 
 
       
 
      /** 
 
       *  
 
       * Realiza la exportacion de datos a excell 
 
       *  
 
       * @param obj      Referencia a un objeto con datos a exportar 
 
       * @param obj      Nombre default del archivo 
 
       * @param params   Datos opcionales dependiendo de lo que se quiera exportar. 
 
       *  
 
       */ 
 
      static public function export(obj:Object, defaultName:String, params:Object = null):void 
 
      { 
 
         if (obj == null || defaultName == null || defaultName == "") 
 
         { 
 
            return 
 
         } 
 
         else if ( obj is ChartBase ) 
 
         { 
 
            ExcelExport.fromChart( 
 
                     obj as ChartBase,  
 
                     defaultName,  
 
                     params 
 
                     ); 
 
         } 
 
         else if (obj is DataGrid || obj is AdvancedDataGrid || obj is OLAPDataGrid) 
 
         { 
 
            ExcelExport.fromGrid( 
 
                        obj,  
 
                        defaultName,  
 
                        params 
 
                        ) 
 
         }  
 
         else if (obj is XML || obj is XMLList || obj is Array || obj is ICollectionView) 
 
         { 
 
            ExcelExport.fromObject( 
 
                        obj,  
 
                        defaultName, 
 
                        params 
 
                        ); 
 
         } 
 
          
 
         return; 
 
      } 
 
       
 
      //----------------------------- 
 
      // Private function 
 
      //----------------------------- 
 
      /** 
 
       *  
 
       * Genera el archivo excel a partir de una colección de datos 
 
       *  
 
       * @param obj          Colección de datos 
 
       * @colsValues         Listado de objetos que indican cual es el nombre de la columna 
 
       *                   y que propiedad del objeto se utiliza para sacar los datos de la columna 
 
       *                   {header:"nombre del header", value:"propiedad del objeto que contiene el valor"} 
 
       * @param defaultName   Nombre default con el que se genera el excel exportToFile 
 
       *  
 
       */ 
 
      static private function exportToExcel(obj:ICollectionView, colsValues:Array, defaultName:String):void 
 
      { 
 
         if ( obj == null || colsValues == null || colsValues.length == 0) 
 
            return; 
 
          
 
         var rows:Number = 0; 
 
         var cols:Number = 0; 
 
         var cantCols:Number = colsValues.length; 
 
         var sheet:Sheet = new Sheet(); 
 
         sheet.resize(obj.length, colsValues.length); 
 
          
 
         for ( ; cols < cantCols; cols++) 
 
         { 
 
            sheet.setCell(rows, cols, colsValues[cols].header); 
 
         } 
 
          
 
         cols = 0; 
 
         rows++; 
 
         var cursor:IViewCursor = obj.createCursor(); 
 
         while ( !cursor.afterLast ) 
 
         { 
 
            for (cols = 0 ; cols < cantCols; cols++) 
 
            { 
 
               if ( (cursor.current as Object).hasOwnProperty(colsValues[cols].value) ) 
 
                     sheet.setCell(rows, cols, (cursor.current as Object)[colsValues[cols].value]); 
 
            } 
 
             
 
            rows++; 
 
            cursor.moveNext(); 
 
         } 
 
          
 
         var xls:ExcelFile = new ExcelFile(); 
 
         xls.sheets.addItem(sheet); 
 
         var bytes:ByteArray = xls.saveToByteArray(); 
 
          
 
         var fr:FileReference = new FileReference(); 
 
         fr.save(bytes, defaultName); 
 
      } 
 
      /** 
 
       *  
 
       * A partir de un elemento pasado se genera un ICollectionView 
 
       * para su correcto recorrido 
 
       *  
 
       * @param obj         Objeto a convertir a ICollectionView 
 
       *  
 
       *  
 
       * @return referencia a un ICollectionView.  
 
       *  
 
       */ 
 
      static private function getDataProviderCollection(obj:Object):ICollectionView 
 
      { 
 
         if ( (obj is Number && isNaN(obj as Number)) || (!(obj is Number) && obj == null)) 
 
         { 
 
            return null; 
 
         } 
 
         else if ( obj is ICollectionView ) 
 
         { 
 
            return obj as ICollectionView; 
 
         } 
 
         else if ( obj is Array ) 
 
         { 
 
            return new ArrayCollection(obj as Array); 
 
         } 
 
         else if ( obj is XMLList ) 
 
         { 
 
            return new XMLListCollection(obj as XMLList); 
 
         } 
 
         else if ( obj is XML ) 
 
         { 
 
            var col:XMLListCollection = new XMLListCollection(); 
 
            col.addItem(obj); 
 
            return col; 
 
         } 
 
         else if ( obj is Object ) 
 
         { 
 
            return new ArrayCollection([obj]); 
 
         } 
 
         else 
 
         { 
 
            return null; 
 
         } 
 
      } 
 
       
 
      /** 
 
       * {header:nombre de la columna, value:nombre de la propiedad del objeto} 
 
       */ 
 
      static private function generateColsValues(dp:Array, headerName:String, valueName:String, extraColumsBefore:Array = null, extraColumnsAfter:Array = null):Array 
 
      { 
 
         var cant:Number = dp.length; 
 
         var colsValues:Array = []; 
 
         var fieldT:String; 
 
         var headerT:String; 
 
          
 
         for (var i:Number = 0; i < cant; i++) 
 
         { 
 
            if (dp[i].hasOwnProperty(headerName) && dp[i].hasOwnProperty(valueName)) 
 
            { 
 
               headerT = dp[i][headerName]; 
 
               fieldT = dp[i][valueName]; 
 
               if ( fieldT == null || fieldT == "" || headerT == null || headerT == "") 
 
                  continue;  
 
               colsValues.push({ 
 
                           header:headerT, 
 
                           value:fieldT 
 
               }); 
 
            } 
 
         } 
 
          
 
         if ( extraColumsBefore && extraColumsBefore.length > 0 ) 
 
            colsValues = extraColumsBefore.concat(colsValues) 
 
         if ( extraColumnsAfter && extraColumnsAfter.length > 0 ) 
 
            colsValues = colsValues.concat(extraColumnsAfter); 
 
          
 
         return colsValues; 
 
      } 
 
   } 
}