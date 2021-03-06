﻿shipout := new Shipout()
if not Pwb := IETitle("ESOLBRANCH LIVE DB / \w+ / DLL Ver: " TesseractVersion " / Page Ver: " TesseractVersion) {
	msgbox, Failed to connect to Page
	return
}

if not JobType:= shipout.getJobType(Pwb) {
	msgbox, Failed to get job type
	return
}
if not ShipSite:= shipout.getShipSite(Pwb){
	msgbox, failed to get ship site
	return
}
if (shipsite = "ZULU") {
	zuluShipout(Pwb)
} else {
	oldShipout(Pwb)
}
return

class Shipout {
	getJobType(Pwb){
		frame := Pwb.document.all(10).contentWindow
		try {
			JobType := frame.document.getElementByID("cboJobFlowCode").value
			return JobType
		} catch {
			return False
		}
		
	}
	getShipSite(Pwb){
		frame := Pwb.document.all(10).contentWindow
		try {
			ShipSite := frame.document.getElementById("cboJobShipSiteNum").value
			return ShipSite
		} catch {
			return false
		}
	}
	
}


zuluShipout(Pwb){
	Loop{
		Try{
			frame := Pwb.document.all(10).contentWindow
			PageLoaded:= frame.document.getElementsByTagName("Label")[0].innertext
		}
	}Until (PageLoaded = "Job Details")
	PageLoaded:=""
	frame := Pwb.document.all(10).contentWindow
	frame.document.getElementByID("cboJobFlowCode").value:="ZULUAW"
	frame.document.getElementByID("cboCallAreaCode").value:="WSF"
	
	sleep, 250
	frame := Pwb.document.all(7).contentWindow
	Loop{
		Try{
			PageLoaded:= frame.document.getElementByID("cmdSubmit").value
		}
	}Until (PageLoaded = "submit")
	PageLoaded:=""
	frame.document.getElementById("cmdSubmit").click
	pageloading(pwb)
	sleep, 500
	frame := Pwb.document.all(10).contentWindow
	frame.document.getElementById("cboCallUpdAreaCode").value := "WSF"
	ModalDialogue()
	frame.document.getElementsByTagName("IMG")[35].click
	WinWaitClose,Popup List -- Webpage Dialog,,5
	frame := Pwb.document.all(7).contentWindow
	frame.document.getElementById("cmdSubmit").click
	PageAlert()
	return
}

oldShipout(Pwb){ 
	frame := Pwb.document.all(10).contentWindow
	CallNum := ShipSite:= frame.document.getElementById("txtCallNum") .value
	ShipSite:= frame.document.getElementById("cboJobShipSiteNum") .value
	sleep, 250
	frame := Pwb.document.all(9).contentWindow
	frame.document.getElementById("lblJobShipOutWizard") .click
	IELoad(pwb)
	Pwb.document.getElementById("txtInputJobNum") .value :=CallNum
	Pwb.document.getElementById("cmdAddJobNum") .click
	Pwb.document.getElementById("cmdNext") .click
	IELoad(Pwb)
	Pwb.document.getElementById("cmdNext") .click
	IELoad(Pwb)
	Pwb.document.getElementsByTagName("INPUT")[48] .click
	SerialNumber:=Pwb.document.getElementbyID("cbaListCallSerNumLineArray").value
	ProdCode:=Pwb.document.getElementbyID("cbaListJobPartNumLineArray").value
	Pwb.document.getElementById("cmdFinish") .click
	PageAlert()
	IELoad(Pwb)
	Pwb.document.getElementsByTagName("INPUT")[40] .click
	Pwb.document.getElementById("cmdFinish") .click
	return
}