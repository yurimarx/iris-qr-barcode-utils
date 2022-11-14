Class dc.qrbarcode.QRBarcodeRESTApp Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONVERTINPUTSTREAM = 1;

Parameter CONTENTTYPE = "application/json";

Parameter Version = "1.0.0";

Parameter HandleCorsRequest = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<!-- Server Info -->
<Route Url="/" Method="GET" Call="GetInfo" Cors="true"/>
<!-- Swagger specs -->
<Route Url="/_spec" Method="GET" Call="SwaggerSpec" />

<!-- Read QRcode and Barcode from image -->
<Route Url="/qrbarcodefromimage" Method="POST" Call="GetQRBarcodeFromImage" />

<!-- Read QRcode and Barcode from PDF -->
<Route Url="/qrbarcodefrompdf" Method="POST" Call="GetQRBarcodeFromPDF" />


<!-- Write QRcode and Barcodes to image -->
<Route Url="/writeqrbarcodetoimage/:number/:imagename" Method="GET" Call="WriteBarcodeToImage" />


</Routes>
}

ClassMethod WriteBarcodeToImage(number As %Integer, imagename As %String) As %Status
{
  set sc = $$$OK
  Set %response.ContentType = "image/png"
  Do %response.SetHeader("Content-Disposition","attachment;filename="""_imagename_"""")
  Set %response.Status = 200 
  Set %response.NoCharSetConvert=1
  Set %response.Headers("Access-Control-Allow-Origin")="*"
  Set result = ##class(dc.qrbarcode.QRBarcodeService).WriteBarcodeToImage(number, imagename)
  Set stream=##class(%Stream.FileBinary).%New()
  Set sc=stream.LinkToFile(result)
  Do stream.OutputToDevice()
  Quit sc
}

/// Read QRcode and Barcode from image
ClassMethod GetQRBarcodeFromImage() As %Status
{
    Try {
      Set info = {}
      Set source = %request.GetMimeData("file")
      Set destination=##class(%Stream.FileBinary).%New()
      Set Filename = "/opt/irisbuild/images/"_source.FileName
      Set destination.Filename = Filename
      set tSC=destination.CopyFrom(source) //reader open the file
      set Image=destination.%Save()
      Set Response = ##class(dc.qrbarcode.QRBarcodeService).ReadQRBarcodeFromImage(Filename)
      Set %response.Status = 200 
      Set %response.Headers("Access-Control-Allow-Origin")="*"
      Write Response
      //Write Filename
      Return $$$OK
    } Catch err {
      write !, "Error name: ", ?20, err.Name,
          !, "Error code: ", ?20, err.Code,
          !, "Error location: ", ?20, err.Location,
          !, "Additional data: ", ?20, err.Data, !
      Return $$$NOTOK
  }
}

/// Read QRcode and Barcode from PDF
ClassMethod GetQRBarcodeFromPDF() As %Status
{
    Try {
      Set info = {}
      Set source = %request.GetMimeData("file")
      Set destination=##class(%Stream.FileBinary).%New()
      Set Filename = "/opt/irisbuild/images/"_source.FileName
      Set destination.Filename = Filename
      set tSC=destination.CopyFrom(source) //reader open the file
      set Image=destination.%Save()
      Set Response = ##class(dc.qrbarcode.QRBarcodeService).ReadQRBarcodeFromPDF(Filename)
      Set %response.Status = 200 
      Set %response.Headers("Access-Control-Allow-Origin")="*"
      Write Response
      //Write Filename
      Return $$$OK
    } Catch err {
      write !, "Error name: ", ?20, err.Name,
          !, "Error code: ", ?20, err.Code,
          !, "Error location: ", ?20, err.Location,
          !, "Additional data: ", ?20, err.Data, !
      Return $$$NOTOK
  }
}

/// General information
ClassMethod GetInfo() As %Status
{
  SET version = ..#Version
  SET fmt=##class(%SYS.NLS.Format).%New("ptbw")
  
  SET info = {
    "Service": "Geocoder Service API",
    "version": (version),
    "Developer": "Yuri Gomes",
    "Status": "Ok",
    "Date": ($ZDATETIME($HOROLOG))
  }
  Set %response.ContentType = ..#CONTENTTYPEJSON
  Set %response.Headers("Access-Control-Allow-Origin")="*"

  Write info.%ToJSON()
  Quit $$$OK
}

ClassMethod SwaggerSpec() As %Status
{
  Set tSC = ##class(%REST.API).GetWebRESTApplication($NAMESPACE, %request.Application, .swagger)
  Do swagger.info.%Remove("x-ISC_Namespace")
  Set swagger.basePath = "/iris-tts" 
  Set swagger.info.title = "TTS Service API"
  Set swagger.info.version = "1.0"
  Set swagger.host = "localhost:52773"
  Return ..%ProcessResult($$$OK, swagger)
}

ClassMethod %ProcessResult(pStatus As %Status = {$$$OK}, pResult As %DynamicObject = "") As %Status [ Internal ]
{
  #dim %response As %CSP.Response
  SET tSC = $$$OK
  IF $$$ISERR(pStatus) {
    SET %response.Status = 500
    SET tSC = ..StatusToJSON(pStatus, .tJSON)
    IF $isobject(tJSON) {
      SET pResult = tJSON
    } ELSE {
      SET pResult = { "errors": [ { "error": "Unknown error parsing status code" } ] }
    }
  } 
  ELSEIF pStatus=1 {
    IF '$isobject(pResult){
      SET pResult = {
      }
    }
  }
  ELSE {
    SET %response.Status = pStatus
    SET error = $PIECE(pStatus, " ", 2, *)
    SET pResult = {
      "error": (error)
    }
  }
  
  IF pResult.%Extends("%Library.DynamicAbstractObject") {
    WRITE pResult.%ToJSON()
  }
  ELSEIF pResult.%Extends("%JSON.Adaptor") {
    DO pResult.%JSONExport()
  }
  ELSEIF pResult.%Extends("%Stream.Object") {
    DO pResult.OutputToDevice()
  }
  
  QUIT tSC
}

}
