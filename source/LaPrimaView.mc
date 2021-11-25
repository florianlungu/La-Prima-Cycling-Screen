//! @author Florian Lungu 2017
using Toybox.WatchUi as Ui;
using Toybox.Graphics;
using Toybox.System as Sys;

class LaPrimaView extends Ui.DataField {

	hidden var fields;

	function initialize() {
		DataField.initialize();
		fields=new LaPrimaFields();
	}

	function onLayout(dc) {
	}

	function onShow() {
	}

	function onHide() {
	}

	function drawLayout(dc,fc) {
		if (fields.sColor!=null) {
			switch (fields.sColor) {
				case 0:	{dc.setColor(Graphics.COLOR_BLUE,fc);break;}
				case 1:	{dc.setColor(0x2AA670,fc);break;}
				case 2:	{dc.setColor(0xFF7120,fc);break;}
				case 3:	{dc.setColor(0xFF6FA3,fc);break;}
				case 4:	{dc.setColor(0xAE5AE9,fc);break;}
				case 5:	{dc.setColor(0xD62A16,fc);break;}
				case 6:	{dc.setColor(0xFFC425,fc);break;}
				case 7:	{dc.setColor(0xFF0080,fc);break;}
				case 8:	{dc.setColor(0x0073CF,fc);break;}
				case 9:	{dc.setColor(0x00FF00,fc);break;}
				case 10:{dc.setColor(0x000000,fc);break;}
				case 11:{dc.setColor(0xFF2800,fc);break;}
			}
		} else {
			if (getBackgroundColor()==0x000000) {
				dc.setColor(0x000000,fc);
			} else {
				dc.setColor(0xFFFFFF,fc);
			}
		}
		if (dc.getHeight()==470) {
			dc.fillRectangle(0,dc.getHeight()-98,dc.getWidth(),98);
		} else if (dc.getHeight()==400) {
			dc.fillRectangle(0,dc.getHeight()-82,dc.getWidth(),82);
		} else if (dc.getHeight()==322) {
			dc.fillRectangle(0,dc.getHeight()-75,dc.getWidth(),75);
		} else {
			dc.fillRectangle(0,dc.getHeight()-68,dc.getWidth(),68);
		}
	}

	function drawGPS(myGPS,dc,fc,row,loc) {
		dc.setColor(fc,-1);
		dc.drawRectangle(loc-10,row+10,4,4);
		dc.drawRectangle(loc-5,row+7,4,7);
		dc.drawRectangle(loc,row+4,4,10);
		dc.drawRectangle(loc+5,row+1,4,13);
		if (myGPS>=1) {
			dc.fillRectangle(loc-10,row+10,4,4);
		}
		if (myGPS>=2) {
			dc.fillRectangle(loc-5,row+7,4,7);
		}
		if (myGPS>=3) {
			dc.fillRectangle(loc,row+4,4,10);
		}
		if (myGPS>=4) {
			dc.fillRectangle(loc+5,row+1,4,13);
		}
	}

	function onUpdate(dc) {
		var row1=1;
		var row2=1;
		var row3=1;
		var row4=1;
		var row5=1;
		var row6=1;
		var row7=1;
		var pwrLocLab=1;
		var hrLocLab=1;
		var distLocLab=1;
		var fc=0xFFFFFF;
		var sidePad=10;
		var topPad=0;
		var midPad=0;
		var imgAdj=0;
		var lowPad=0;

		if (getBackgroundColor()==0x000000) {
			fc=0xFFFFFF;
		} else {
			fc=0x000000;
		}

		if (dc.getHeight()==470) {
			row1=dc.getHeight()-422;
			row2=dc.getHeight()-318;
			row3=dc.getHeight()-275;
			row4=dc.getHeight()-208;
			row5=dc.getHeight()-165;
			row6=dc.getHeight()-87;
			row7=dc.getHeight()-36;
			sidePad=30;
			topPad=16;
			midPad=3;
			imgAdj=8;
			lowPad=2;
		} else if (dc.getHeight()==400) {
			row1=dc.getHeight()-362;
			row2=dc.getHeight()-268;
			row3=dc.getHeight()-225;
			row4=dc.getHeight()-168;
			row5=dc.getHeight()-125;
			row6=dc.getHeight()-69;
			row7=dc.getHeight()-28;
			sidePad=25;
			topPad=9;
			midPad=2;
		} else if (dc.getHeight()==322) {
			row1=dc.getHeight()-303;
			row2=dc.getHeight()-229;
			row3=dc.getHeight()-192;
			row4=dc.getHeight()-147;
			row5=dc.getHeight()-109;
			row6=dc.getHeight()-70;
			row7=dc.getHeight()-26;
			sidePad=25;
			topPad=7;
			imgAdj=4;
		} else {
			row1=dc.getHeight()-248;
			row2=dc.getHeight()-190;
			row3=dc.getHeight()-158;
			row4=dc.getHeight()-125;
			row5=dc.getHeight()-93;
			row6=dc.getHeight()-58;
			row7=dc.getHeight()-23;
		}

		var spdLab=(dc.getWidth()+dc.getTextWidthInPixels(fields.Spd,17))/2+3;
		var pwrLoc=dc.getWidth()/4;
		if (fields.rideWith==3) {
			pwrLocLab=pwrLoc+dc.getTextWidthInPixels(fields.aSpd.format("%.1f"),6)/2+3;
		} else {
			pwrLocLab=pwrLoc+dc.getTextWidthInPixels(fields.Pwr.toString(),6)/2+3;
		}
		var hrLoc=(dc.getWidth()/2)+(dc.getWidth()/4)-5;
		if (fields.rideWith==2) {
			hrLocLab=hrLoc+dc.getTextWidthInPixels(fields.myNP.format("%d"),6)/2+3;
		} else {
			hrLocLab=hrLoc+dc.getTextWidthInPixels(fields.curHR.toString(),6)/2+3;
		}

		var leftOptTwoA=sidePad;
		var leftOptTwoB=dc.getWidth()/2-12;
		var leftOptOne=dc.getWidth()/4;
		var rightOptTwoA=dc.getWidth()/2+12;
		var rightOptTwoB=dc.getWidth()-sidePad;
		var rightOptOne=(dc.getWidth()/2)+(dc.getWidth()/4);

		var cadLoc=dc.getWidth()/4;
		var cadLocLab=cadLoc+dc.getTextWidthInPixels(fields.Cad.toString(),6)/2+3;
		var distLoc=(dc.getWidth()/2)+(dc.getWidth()/4)-5;
		if (fields.Dist>=99.95) {
			distLocLab=distLoc+dc.getTextWidthInPixels(fields.Dist.format("%.1f"),5)/2+3;
		} else if (fields.Dist>=9.99) {
			distLocLab=distLoc+dc.getTextWidthInPixels(fields.Dist.format("%.1f"),6)/2+3;
		} else {
			distLocLab=distLoc+dc.getTextWidthInPixels(fields.Dist.format("%.2f"),6)/2+3;
		}

		dc.setColor(fc,-1);
		dc.clear();

		drawT(dc,((dc.getWidth()-dc.getTextWidthInPixels(fields.Spd,17))/2),row1,17,fields.Spd,2);
		drawT(dc,spdLab,row1+2+topPad,1,fields.SpdLab,2);
		drawT(dc,spdLab,row1+16+topPad,1,"P",2);
		drawT(dc,spdLab,row1+30+topPad,1,"H",2);

		if (fields.rideWith==3) {
			drawT(dc,pwrLoc,row2,6,fields.aSpd.format("%.1f"),1);
			drawT(dc,pwrLocLab,row2+midPad,9,fields.SpdLab,2);
			drawT(dc,pwrLocLab,row2+10+midPad,9,"P",2);
			drawT(dc,pwrLocLab,row2+20+midPad,9,"H",2);
		} else {
			drawT(dc,pwrLoc,row2,6,fields.Pwr.toString(),1);
			drawT(dc,pwrLocLab,row2+20+midPad,9,"W",2);
		}
		if (fields.rideWith==2) {
			drawT(dc,hrLoc,row2,6,fields.myNP.format("%d"),1);
			drawT(dc,hrLocLab,row2+20+midPad,9,"W",2);
		} else {
			drawT(dc,hrLoc,row2,6,fields.curHR.toString(),1);
			drawT(dc,hrLocLab,row2+midPad,9,"B",2);
			drawT(dc,hrLocLab,row2+10+midPad,9,"P",2);
			drawT(dc,hrLocLab,row2+20+midPad,9,"M",2);
		}

		if (fields.oFld1b.length()==0) {
			drawT(dc,leftOptOne,row3,2,fields.oFld1a,1);
		} else {
			drawT(dc,leftOptTwoA,row3,2,fields.oFld1a,2);
			drawT(dc,leftOptTwoB,row3,2,fields.oFld1b,0);
		}
		if (fields.oFld2b.length()==0) {
			drawT(dc,rightOptOne,row3,2,fields.oFld2a,1);
		} else {
			drawT(dc,rightOptTwoA,row3,2,fields.oFld2a,2);
			drawT(dc,rightOptTwoB,row3,2,fields.oFld2b,0);
		}
		if (fields.oFld3b.length()==0) {
			drawT(dc,leftOptOne,row5,2,fields.oFld3a,1);
		} else {
			drawT(dc,leftOptTwoA,row5,2,fields.oFld3a,2);
			drawT(dc,leftOptTwoB,row5,2,fields.oFld3b,0);
		}
		if (fields.oFld4b.length()==0) {
			drawT(dc,rightOptOne,row5,2,fields.oFld4a,1);
		} else {
			drawT(dc,rightOptTwoA,row5,2,fields.oFld4a,2);
			drawT(dc,rightOptTwoB,row5,2,fields.oFld4b,0);
		}

		drawT(dc,cadLoc,row4,6,fields.Cad.toString(),1);
		drawT(dc,cadLocLab,row4+midPad,9,"R",2);
		drawT(dc,cadLocLab,row4+10+midPad,9,"P",2);
		drawT(dc,cadLocLab,row4+20+midPad,9,"M",2);

		if (fields.Dist>=99.95) {
			drawT(dc,distLoc,row4+4,5,fields.Dist.format("%.1f"),1);
		} else if (fields.Dist>=9.99) {
			drawT(dc,distLoc,row4,6,fields.Dist.format("%.1f"),1);
		} else {
			drawT(dc,distLoc,row4,6,fields.Dist.format("%.2f"),1);
		}
		drawT(dc,distLocLab,row4+10+midPad,9,fields.DistLab1,2);
		if (Sys.getDeviceSettings().distanceUnits==Sys.UNIT_METRIC) {
			drawT(dc,distLocLab,row4+20+midPad,9,fields.DistLab2,2);
		} else {
			drawT(dc,distLocLab+2,row4+20+midPad,9,fields.DistLab2,2);
		}

		drawLayout(dc,fc);

		if (fields.sColor!=null) {
			switch(fields.sColor) {
				case 10:
					fc=0xA1A7AB;
					break;
				case 4:
				case 5:
				case 7:
				case 8:
				case 11:
					fc=0xFFFFFF;
					break;
				case 0:
				case 2:
				case 3:
				case 6:
				case 9:
					fc=0x000000;
					break;
			}
		}

		dc.setColor(fc,-1);
		drawT(dc,dc.getWidth()/2-(dc.getTextWidthInPixels(fields.eTime,4)/2),row6,4,fields.eTime,2);
		drawT(dc,sidePad,row7,2,fields.myTime,2);
		drawT(dc,(dc.getWidth()/2)-11-dc.getTextWidthInPixels(fields.Tempr,1),row7,2,fields.Tempr,2);
		drawGPS(fields.myGPS,dc,fc,row7+imgAdj,(dc.getWidth()/2)+21);		
		drawT(dc,(dc.getWidth()-sidePad),row7,2,fields.myBat,0);
		var batIc=dc.getWidth()-15-sidePad-dc.getTextWidthInPixels(fields.myBat,1)-(lowPad*2);
		row7+=lowPad+2;
		dc.fillPolygon([[5+batIc,2+row7],[2+batIc,10+row7],[5+batIc,10+row7],[5+batIc,16+row7],[8+batIc,8+row7],[5+batIc,8+row7]]);
		return true;
	}

	function compute(info) {
		fields.compute(info);
		return 1;
	}

	function drawT(dc,x,y,font,s,d) {		
		if (s!=null && s instanceof String && x instanceof Number && y instanceof Number) {
			dc.drawText(x,y,font,s,d);
		}
	}
}