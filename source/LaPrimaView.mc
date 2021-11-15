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
		var batPadL=0;
		var batPadR=0;
		var batPadT=0;
		var imgAdj=0;

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
			row6=dc.getHeight()-82;
			row7=dc.getHeight()-35;
			sidePad=15;
			topPad=6;
			batPadL=-11;
			batPadR=-5;
			batPadT=-2;
		} else if (dc.getHeight()==400) {
			row1=dc.getHeight()-362;
			row2=dc.getHeight()-268;
			row3=dc.getHeight()-225;
			row4=dc.getHeight()-168;
			row5=dc.getHeight()-125;
			row6=dc.getHeight()-69;
			row7=dc.getHeight()-28;
			sidePad=15;
			topPad=9;
			midPad=2;
		} else if (dc.getHeight()==322) {
			row1=dc.getHeight()-305;
			row2=dc.getHeight()-229;
			row3=dc.getHeight()-192;
			row4=dc.getHeight()-147;
			row5=dc.getHeight()-109;
			row6=dc.getHeight()-70;
			row7=dc.getHeight()-26;
			sidePad=25;
			topPad=6;
			midPad=2;
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

		var batImgLoc=dc.getWidth()-42-sidePad;
		var batImgRow=row7-2+imgAdj;

		dc.setColor(fc,-1);
		dc.clear();

		textL(dc,((dc.getWidth()-dc.getTextWidthInPixels(fields.Spd,17))/2),row1,17,fields.Spd);
		textL(dc,spdLab,row1+2+topPad,1,fields.SpdLab);
		textL(dc,spdLab,row1+16+topPad,1,"P");
		textL(dc,spdLab,row1+30+topPad,1,"H");

		if (fields.rideWith==3) {
			textC(dc,pwrLoc,row2,6,fields.aSpd.format("%.1f"));
			textL(dc,pwrLocLab,row2+midPad,9,fields.SpdLab);
			textL(dc,pwrLocLab,row2+10+midPad,9,"P");
			textL(dc,pwrLocLab,row2+20+midPad,9,"H");
		} else {
			textC(dc,pwrLoc,row2,6,fields.Pwr.toString());
			textL(dc,pwrLocLab,row2+20+midPad,9,"W");
		}
		if (fields.rideWith==2) {
			textC(dc,hrLoc,row2,6,fields.myNP.format("%d"));
			textL(dc,hrLocLab,row2+20+midPad,9,"W");
		} else {
			textC(dc,hrLoc,row2,6,fields.curHR.toString());
			textL(dc,hrLocLab,row2+midPad,9,"B");
			textL(dc,hrLocLab,row2+10+midPad,9,"P");
			textL(dc,hrLocLab,row2+20+midPad,9,"M");
		}

		if (fields.oFld1b.length()==0) {
			textC(dc,leftOptOne,row3,2,fields.oFld1a);
		} else {
			textL(dc,leftOptTwoA,row3,2,fields.oFld1a);
			textR(dc,leftOptTwoB,row3,2,fields.oFld1b);
		}
		if (fields.oFld2b.length()==0) {
			textC(dc,rightOptOne,row3,2,fields.oFld2a);
		} else {
			textL(dc,rightOptTwoA,row3,2,fields.oFld2a);
			textR(dc,rightOptTwoB,row3,2,fields.oFld2b);
		}
		if (fields.oFld3b.length()==0) {
			textC(dc,leftOptOne,row5,2,fields.oFld3a);
		} else {
			textL(dc,leftOptTwoA,row5,2,fields.oFld3a);
			textR(dc,leftOptTwoB,row5,2,fields.oFld3b);
		}
		if (fields.oFld4b.length()==0) {
			textC(dc,rightOptOne,row5,2,fields.oFld4a);
		} else {
			textL(dc,rightOptTwoA,row5,2,fields.oFld4a);
			textR(dc,rightOptTwoB,row5,2,fields.oFld4b);
		}

		textC(dc,cadLoc,row4,6,fields.Cad.toString());
		textL(dc,cadLocLab,row4+midPad,9,"R");
		textL(dc,cadLocLab,row4+10+midPad,9,"P");
		textL(dc,cadLocLab,row4+20+midPad,9,"M");

		if (fields.Dist>=99.95) {
			textC(dc,distLoc,row4+4,5,fields.Dist.format("%.1f"));
		} else if (fields.Dist>=9.99) {
			textC(dc,distLoc,row4,6,fields.Dist.format("%.1f"));
		} else {
			textC(dc,distLoc,row4,6,fields.Dist.format("%.2f"));
		}
		textL(dc,distLocLab,row4+10+midPad,9,fields.DistLab1);
		if (Sys.getDeviceSettings().distanceUnits==Sys.UNIT_METRIC) {
			textL(dc,distLocLab,row4+20+midPad,9,fields.DistLab2);
		} else {
			textL(dc,distLocLab+2,row4+20+midPad,9,fields.DistLab2);
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
		textL(dc,dc.getWidth()/2-(dc.getTextWidthInPixels(fields.eTime,4)/2),row6,4,fields.eTime);

		textL(dc,sidePad,row7,2,fields.myTime);
		textL(dc,(dc.getWidth()/2)-11-dc.getTextWidthInPixels(fields.Tempr,1),row7,2,fields.Tempr);
		drawGPS(fields.myGPS,dc,fc,row7+imgAdj,(dc.getWidth()/2)+21);
		textL(dc,(dc.getWidth()-20-sidePad-(dc.getTextWidthInPixels(fields.myBat,1)/2))+batPadR,row7,1,fields.myBat);

		dc.setColor(fc,-1);
		dc.drawLine(batImgLoc+batPadL,batImgRow+batPadT,batImgLoc+41,batImgRow+batPadT);
		dc.drawLine(batImgLoc+41,batImgRow+batPadT,batImgLoc+41,batImgRow+16);
		dc.drawLine(batImgLoc+batPadL,batImgRow+15,batImgLoc+41,batImgRow+15);
		dc.drawLine(batImgLoc+batPadL,batImgRow+15,batImgLoc+batPadL,batImgRow+12);
		dc.drawLine(batImgLoc+batPadL,batImgRow+12,batImgLoc-4+batPadL,batImgRow+12);
		dc.drawLine(batImgLoc-3+batPadL,batImgRow+11,batImgLoc-3+batPadL,batImgRow+4);
		dc.drawLine(batImgLoc-3+batPadL,batImgRow+4,batImgLoc+1+batPadL,batImgRow+4);
		dc.drawLine(batImgLoc+batPadL,batImgRow+batPadT,batImgLoc+batPadL,batImgRow+4);
		return true;
	}

	function compute(info) {
		fields.compute(info);
		return 1;
	}

	function textL(dc,x,y,font,s) {
		if (s!=null) {
			dc.drawText(x,y,font,s,Graphics.TEXT_JUSTIFY_LEFT);
		}
	}

	function textC(dc,x,y,font,s) {
		if (s!=null) {
			dc.drawText(x,y,font,s,Graphics.TEXT_JUSTIFY_CENTER);
		}
	}

	function textR(dc,x,y,font,s) {
		if (s!=null) {
			dc.drawText(x,y,font,s,Graphics.TEXT_JUSTIFY_RIGHT);
		}
	}
}