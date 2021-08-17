//! @author Florian Lungu 2017
using Toybox.Background;
using Toybox.System as Sys;
using Toybox.Application as App;
using Toybox.Time;

var temp=-100;

class LaPrimaApp extends App.AppBase {

	function initialize() {
		AppBase.initialize();
	}

	function onStart(state) {
	}

	function onStop(state) {
	}

	function getInitialView() {
	    if(Toybox.System has :ServiceDelegate) {
	        Background.registerForTemporalEvent(new Time.Duration(300));
	    }
	    return [ new LaPrimaView() ];
	}

	function onBackgroundData(data) {
	    temp=data;
	}

	function getServiceDelegate() {
	    return [new TempBgServiceDelegate()];
	}

	(:background)
	class TempBgServiceDelegate extends Toybox.System.ServiceDelegate {
	    function initialize() {
	        Sys.ServiceDelegate.initialize();
	    }

	    function onTemporalEvent() {
	        var si=Sensor.getInfo();
	        Background.exit(si.temperature);
	    }
	}
}
