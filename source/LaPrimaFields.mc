//! @author Florian Lungu 2017
using Toybox.Time as Time;
using Toybox.System as Sys;
using Toybox.UserProfile;
using Toybox.Application as App;

class LaPrimaFields {

	var FTP;
	var PowerDisp;
	var TimeDisp;
	var sColor;
	var Spd="0";
	var SpdLab="";
	var cPwr=0;
	var Pwr=0;
	var PwrZ=0;
	var PwrT=0;
	var curHR=0;
	var HRZ=0;
	var HRP=0;
	var Cad=0;
	var avgPwr=0;
	var avgPwr10=0;
	var avgPwr30=0;
	var avgPwrKG=0;
	var aSpd="0";
	var aPwr10=new[10];
	var aI10=0;
	var aPwr3=new[3];
	var aI3=0;
	var aPwr30=new[30];
	var aI30=0;
	var Dist=0;
	var DistLab1;
	var DistLab2;
	var myElev=0;
	var myElevFmt="0";
	var myElevLab= " ";
	var eTime="--:--";
	var myTime="--:--";
	var Tempr="";
	var myBat="0";
	var Cal=0;
	var CalFmt="0";
	var work=0;
	var workFmt="0";
	var myGPS=0;
	var myNP=0.0d;
	var totalNP=0l;
	var totalNPSize=0;
	var aNPwr30=new[30];
	var aNPwrI30=0;
	var f30Pwr=0;
	var NP30s=0.0d;
	var Inten=0;
	var TSS=0;
	var cTSS=0;
	var TSSFmt="";
	var HRavg=0;
	var rideWith=0;
	var hasHR=0;
	var hasPwr=0;

	var oVal1="";
	var oVal2="";
	var oFld1a="";
	var oFld1b="";
	var oFld2a="";
	var oFld2b="";
	var oFld3a="";
	var oFld3b="";
	var oFld4a="";
	var oFld4b="";
	var mHRZ=0;
	var xFld=0;
	var xFld1=0;
	var xFld2=20;
	var xFld3=1;
	var xFld4=32;

	function fmtTime(clock) {
		var h=clock.hour;
		var h2;
		if (!Sys.getDeviceSettings().is24Hour) {
			if (h>12) {
				h-=12;
			} else if (h==0) {
				h+=12;
			}
			h2=h;
		} else {
			h2=clock.hour.format("%02d");
		}
		return ""+h2+":"+clock.min.format("%02d");
	}

	function fmtTemperature(a) {
		var ret;
		if (Sys.getDeviceSettings().distanceUnits==Sys.UNIT_METRIC) {
			ret=a;
		} else {
			ret=a*9.0/5.0+32.0;
		}
		return ret.format("%d");
	}

	function toDist(value) {
		var ret=value/1000.0;
		if (Sys.getDeviceSettings().distanceUnits==Sys.UNIT_STATUTE) {
			ret=ret*0.621371;
		}
		return ret;
	}

	function elapsedTimeFmt(elapsedTime) {
		var ret;
		if (elapsedTime>3599.999) {
			ret=Lang.format("$1$:$2$:$3$",[(elapsedTime/3600) % 24,((elapsedTime/60) % 60).format("%02d"),(elapsedTime % 60).format("%02d")]);
		} else {
			ret=Lang.format("$1$:$2$",[((elapsedTime/60) % 60).format("%02d"),(elapsedTime%60).format("%02d")]);
		}
		return ret;
	}

	function calculateAverage(sumArray) {
		var sum=0;
		if (sumArray!= null) {
			for (var i=0; i<sumArray.size(); ++i) {
				sum+=sumArray[i];
			}
			return sum/sumArray.size();
		}
		return sum;
	}

	function mod(a, b) {
		var tmp1=a % b;
		if ( tmp1<0 ) {
			tmp1=-tmp1;
		}
		return tmp1;
	}

	function readKeyInt(key,defaultVal) {
		var gVal=Application.Properties.getValue(key);
		var val = defaultVal;
		if (gVal instanceof Number) {
			val=gVal;
		} else if (gVal instanceof String) {
			val=gVal.toNumber();
		}
		return val;
	}

	function compute(info) {

		// pwr & hr avail?
		rideWith=readKeyInt("IRideWith",0);
		if (info.currentPower!=null) {
			cPwr=info.currentPower;
			if (hasPwr==0 and cPwr>0) {
				hasPwr=1;
			}
		} else {
			cPwr=0;
		}
		if (info.currentHeartRate!=null) {
			curHR=info.currentHeartRate;
			if (hasHR==0 and curHR>0) {
				hasHR=1;
			}
		} else {
			curHR=0;
		}
		if (info.elapsedTime!=null) {
			if (info.elapsedTime>0) {
				if (rideWith==0) {
					if (hasPwr==0) {
						rideWith=3;
					} else if (hasHR==0) {
						rideWith=2;
					} else {
						rideWith=0;
					}
				}
			}
		}

		// 1 spd + dist
		if (Sys.getDeviceSettings().distanceUnits==Sys.UNIT_METRIC) {
			SpdLab="K";
			DistLab1="K";
			DistLab2="M";
			if (info.currentSpeed!=null) {
				Spd=(info.currentSpeed*3.6).format("%.1f");
			}
		} else {
			SpdLab="M";
			DistLab1="M";
			DistLab2="I";
			if (info.currentSpeed!=null) {
				Spd=(info.currentSpeed*2.23694).format("%.1f");
			}
		}
		if (info.elapsedDistance!=null) {
			Dist=toDist(info.elapsedDistance);
		}

		// 2 pwr + avg spd
		if (rideWith<3) {
			PowerDisp=readKeyInt("PowerDisplay",0);
			if (PowerDisp==1) {
				if (aPwr3[aI3]==null) {
					for (var i=0; i<aPwr3.size(); ++i) {
						aPwr3[i]=cPwr;
					}
				}
				aPwr3[aI3]=cPwr;
				Pwr=calculateAverage(aPwr3);
				aI3=mod((aI3+1),aPwr3.size());
			} else {
				Pwr=cPwr;
			}
			FTP=readKeyInt("ThesholdPower",250);
			if (FTP<1||FTP>2500) {
				FTP=250;
			}

			if (aPwr10[aI10]==null) {
				for (var i=0; i<aPwr10.size(); ++i) {
					aPwr10[i]=cPwr;
				}
			}
			aPwr10[aI10]=cPwr;
			avgPwr10=calculateAverage(aPwr10);
			aI10=mod((aI10+1),aPwr10.size());

			if (aPwr30[aI30]==null) {
				for (var i=0; i<aPwr30.size(); ++i) {
					aPwr30[i]=cPwr;
				}
			}
			aPwr30[aI30]=cPwr;
			avgPwr30=calculateAverage(aPwr30);
			aI30=mod((aI30+1),aPwr30.size());

			// avg pwr, NP, Int, + TSS
			if (info.averagePower!=null) {
				avgPwr=info.averagePower;
			}
			if (info.timerState==3) {
				if (aNPwr30[aNPwrI30]==null) {
					for (var i=0; i<aNPwr30.size(); ++i) {
						aNPwr30[i]=cPwr;
					}
				}
				aNPwr30[aNPwrI30]=cPwr;
				aNPwrI30=mod((aNPwrI30+1),aNPwr30.size());
				f30Pwr+=1;
				if (f30Pwr>=30) {
					NP30s=0;
					for (var i=0; i<aNPwr30.size(); ++i) {
						NP30s+=(aNPwr30[i]);
					}
					totalNPSize+=1;
					totalNP+=Math.pow((NP30s/30),4);
					myNP=Math.sqrt(Math.sqrt((totalNP/totalNPSize)));
				}
				Inten=myNP/FTP;
				if (info.timerTime!=null) {
					if (f30Pwr>=30) {
						cTSS=(((info.timerTime/1000)-30)*myNP*Inten)/(FTP*3600)*100;
						if (cTSS>=0) {
							TSS=cTSS;
						}
					}
				}
			}

			if (TSS>=9.99) {
				TSSFmt=TSS.format("%d");
			} else {
				TSSFmt=TSS.format("%.1f");
			}

		}

		if (info.timerTime!=null && Dist!=0) {
			aSpd=(Dist/info.timerTime*3600000).format("%.1f");
		}

		// 3 HR
		if (curHR!=0) {
			mHRZ=UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_BIKING);
			if (curHR<mHRZ[0]){
				HRZ=(curHR)/(mHRZ[0]).toFloat();
			} else if (curHR<mHRZ[1]) {
				HRZ=1+((curHR-mHRZ[0])/(mHRZ[1]-mHRZ[0]).toFloat());
			} else if (curHR<mHRZ[2]) {
				HRZ=2+((curHR-mHRZ[1])/(mHRZ[2]-mHRZ[1]).toFloat());
			} else if (curHR<mHRZ[3]){
				HRZ=3+((curHR-mHRZ[2])/(mHRZ[3]-mHRZ[2]).toFloat());
			} else if (curHR<mHRZ[4]){
				HRZ=4+((curHR-mHRZ[3])/(mHRZ[4]-mHRZ[3]).toFloat());
			} else {
				HRZ=5+((curHR-mHRZ[4])/(mHRZ[5]-mHRZ[4]).toFloat());
			}
			if (info.averageHeartRate!=null) {
				HRavg=info.averageHeartRate;
			}
		}

		// 4 Cad
		if (info.currentCadence!=null){
			Cad=info.currentCadence;
		}

		// 5 time temp bat screen color + gps
		TimeDisp=readKeyInt("TimeDisplay",0);
		if (TimeDisp==1) {
			if (info.elapsedTime!=null) {
				var elapsedTime=info.elapsedTime/1000;
				eTime=elapsedTimeFmt(elapsedTime);
			}
		} else {
			if (info.timerTime!=null) {
				var elapsedTime=info.timerTime/1000;
				eTime=elapsedTimeFmt(elapsedTime);
			}
		}
		myTime=fmtTime(Sys.getClockTime());
		var gTmp=App.getApp().temp;
		if (Sys.getDeviceSettings().distanceUnits==Sys.UNIT_METRIC) {
			if (gTmp<-50) {
				Tempr="--C";
			} else {
				Tempr=fmtTemperature(gTmp)+"C";
			}
		} else {
			if (gTmp<-50) {
				Tempr="--F";
			} else {
				Tempr=fmtTemperature(gTmp)+"F";
			}
		}
		var unitStats=Sys.getSystemStats();
		myBat=Lang.format("$1$%",[unitStats.battery.format("%2d")]);
		sColor=readKeyInt("ScrDisplay",0);
		if (info.currentLocationAccuracy!=null) {
			myGPS=info.currentLocationAccuracy;
		}

		// 6 opt fields
		xFld1=readKeyInt("Fld1",0);
		xFld2=readKeyInt("Fld2",20);
		xFld3=readKeyInt("Fld3",1);
		xFld4=readKeyInt("Fld4",32);

		// swap fields if no Pwr or HR
		if (rideWith==3) {
			if (xFld1<20) {
				xFld1=22;
			}
			if (xFld2<20) {
				xFld2=20;
			}
			if (xFld3<20) {
				xFld3=23;
			}
			if (xFld4<20) {
				xFld4=32;
			}
		} else if (rideWith==2) {
			if (xFld1>=20 && xFld1<=30) {
				xFld1=0;
			}
			if (xFld2>=20 && xFld2<=30) {
				xFld2=6;
			}
			if (xFld3>=20 && xFld3<=30) {
				xFld3=7;
			}
			if (xFld4>=20 && xFld4<=30) {
				xFld4=10;
			}
		}

		for (var i2=1; i2<=4; ++i2) {
			oVal1="";
			oVal2="";
			switch(i2) {
				case 1:
					xFld=xFld1;
					break;
				case 2:
					xFld=xFld2;
					break;
				case 3:
					xFld=xFld3;
					break;
				case 4:
					xFld=xFld4;
					break;
			}

			switch(xFld) {
				case 0:
					var PwrT=100*(Pwr)/(FTP).toFloat();
					var PwrZ=0;
					if (PwrT>0) {
						if (PwrT>150) {
							PwrZ=7;
						} else if (PwrT>120) {
							PwrZ=6+((Pwr-FTP*1.20)/(FTP*1.5-FTP*1.20).toFloat());
						} else if (PwrT>105) {
							PwrZ=5+((Pwr-FTP*1.05)/(FTP*1.2-FTP*1.05).toFloat());
						} else if (PwrT>90) {
							PwrZ=4+((Pwr-FTP*.90)/(FTP*1.05-FTP*.90).toFloat());
						} else if (PwrT>75) {
							PwrZ=3+((Pwr-FTP*.75)/(FTP*.90-FTP*.75).toFloat());
						} else if (PwrT>55) {
							PwrZ=2+((Pwr-FTP*.55)/(FTP*.75-FTP*.55).toFloat());
						} else if (PwrT<56) {
							PwrZ=1+(Pwr/(FTP-FTP*.55).toFloat());
						}
					}
					oVal1="z"+PwrZ.format("%.1f");
					oVal2=PwrT.format("%d")+"%";
					break;
				case 1:
					oVal1=avgPwr10.format("%d")+"w / 10s";
					break;
				case 2:
					oVal1=avgPwr30.format("%d")+"w / 30s";
					break;
				case 3:
					oVal1=avgPwr.format("%d")+"w";
					break;
				case 4:
					oVal1=myNP.format("%d")+"w";
					oVal2=avgPwr10.format("%d")+"w";
					break;
				case 5:
					oVal1=myNP.format("%d")+"w";
					oVal2=aSpd.format("%.1f");
					break;
				case 6:
					oVal1=myNP.format("%d")+"w";
					oVal2=(100*Inten).format("%d")+"%";
					break;
				case 7:
					oVal1=TSSFmt;
					oVal2=avgPwr10.format("%d")+"w";
					break;
				case 8:
					oVal1=TSSFmt;
					oVal2=myNP.format("%d")+"w";
					break;
				case 9:
					avgPwrKG=Pwr.toFloat()/(UserProfile.getProfile().weight.toNumber()/1000);
					oVal1=avgPwrKG.format("%.1f")+"w / kg";
					break;
				case 10:
					if (info.averagePower!=null && info.timerTime!=null) {
						work=info.averagePower*info.timerTime/1000/1000;
					} else {
						work=0;
					}
					if (work<1000) {
						workFmt=work.format("%d");
					} else {
						workFmt=(work/1000).format("%d")+","+(work-(1000*((work/1000).format("%03d")).toNumber())).format("%03d");
					}
					oVal1=workFmt+" kJ";
					break;
				case 20:
					if (curHR!=0) {
						HRP=100*(curHR)/(mHRZ[4]).toFloat();
					}
					oVal1="z"+HRZ.format("%.1f");
					oVal2=HRP.format("%d")+"%";
					break;
				case 21:
					if (curHR!=0) {
						HRP=100*(curHR)/(mHRZ[5]).toFloat();
					}
					oVal1="z"+HRZ.format("%.1f");
					oVal2=HRP.format("%d")+"%";
					break;
				case 22:
					if (curHR!=0) {
						oVal2=(100*HRavg/(mHRZ[4]).toFloat()).format("%d")+"%";
					} else {
						oVal2="0%";
					}
					oVal1=HRavg.format("%d");
					break;
				case 23:
					if (info.calories!=null) {
						Cal=info.calories;
					} else {
						Cal=0;
					}
					if (Cal<1000) {
						CalFmt=Cal.format("%d");
					} else {
						CalFmt=(Cal/1000).format("%d")+","+(Cal-(1000*((Cal/1000).format("%03d")).toNumber())).format("%03d");
					}
					oVal1=CalFmt+" kcal";
					break;
				case 31:
					if (info.altitude!=null) {
						if (Sys.getDeviceSettings().distanceUnits==Sys.UNIT_METRIC) {
							myElev=info.altitude;
						} else {
							myElev=info.altitude*3.28084;
						}
					}
					if (myElev!=null) {
						if (myElev<1000) {
							myElevFmt=myElev.format("%d");
						} else {
							myElevFmt=(myElev/1000).format("%d")+","+(myElev-(1000*((myElev/1000).format("%03d")).toNumber())).format("%03d");
						}
					}
					if (Sys.getDeviceSettings().distanceUnits==Sys.UNIT_METRIC) {
						oVal1=myElevFmt+" m";
					} else {
						oVal1=myElevFmt+" ft";
					}
					break;
				case 32:
					if (info.totalAscent!=null) {
						if (Sys.getDeviceSettings().distanceUnits==Sys.UNIT_METRIC) {
							myElev=info.totalAscent;
						} else {
							myElev=info.totalAscent*3.28084;
						}
					}
					if (myElev!=null) {
						if (myElev<1000) {
							myElevFmt=myElev.format("%d");
						} else {
							myElevFmt=(myElev/1000).format("%d")+","+(myElev-(1000*((myElev/1000).format("%03d")).toNumber())).format("%03d");
						}
					}
					if (Sys.getDeviceSettings().distanceUnits==Sys.UNIT_METRIC) {
						oVal1=myElevFmt+" m";
					} else {
						oVal1=myElevFmt+" ft";
					}
					break;
			}

			switch(i2) {
				case 1:
					oFld1a=oVal1;
					oFld1b=oVal2;
					break;
				case 2:
					oFld2a=oVal1;
					oFld2b=oVal2;
					break;
				case 3:
					oFld3a=oVal1;
					oFld3b=oVal2;
					break;
				case 4:
					oFld4a=oVal1;
					oFld4b=oVal2;
					break;
			}
		}
	}
}