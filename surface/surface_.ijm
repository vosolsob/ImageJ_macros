//SURFACE MACRO
//Created by Stanislav Vosolsobě
//unpublished
//Please cite GitHub source directory

//How to use:
//1) Load XYZC hyperstack
//2) Click macro Tool
//3) Select options:
//   base delimiter is used for extraction of base part of the image name, e.g. from "StackO1_ch405/ch488/ch515" wil be extracted "StackO1" using "_" character
//   select channel, whcich will be used for surface detection. Only one channel is analysed, the others are only extracted. Use channel, where is the best visualisation of surface
//   specify, how many slices will be extracted as surface before and after the detected surface.
//   specify the ratio of testing window to the image
//   specify, if default surface is first image or last image. If the very top of the object is missing, select "first"

macro "Extract surface & interior Action Tool - Cf00O11ee" {

//INPUT: Load XYZC hyperstack (e.g. nd5 file)
outdir=getDirectory("image");
Stack.getDimensions(iw, ih, nc, ns, frames);

//Analysis option
im=getImageID();
Dialog.create("Options");
items = newArray(nc);
for (i = 0; i < nc; i++) {
	items[i]= toString(i+1, 0);
}
//CHANGE DEFAULT VALUES HERE:
//Base name delimiter to extract title for image saving
Dialog.addString("Base name delimiter", "_");
//Select channel in witch the surface detection will be performed
Dialog.addRadioButtonGroup("Channel for surface detection", items, nc, 1, 1);
//Number of images before and after surface
Dialog.addNumber("Before surface", 3, 0, 5, "images");
Dialog.addNumber("After surface", 3, 0, 5, "images");
Dialog.addNumber("Testing window size", 0.01, 2, 5, "of image size");
Dialog.addNumber("Surface detection tolerance", 10, 0, 5, "pixel intensity");
defsur=newArray("first","last");
Dialog.addRadioButtonGroup("Default surface", defsur, nc, 1, "last");
Dialog.addCheckbox("Show masks", false);
Dialog.addCheckbox("Show interior", false);
Dialog.addCheckbox("Auto levels in output pictures", true);

Dialog.show;
//Base name delimiter to extract title for image saving
nd=Dialog.getString();
//Select channel in witch the surface detection will be performed
mch=parseInt(Dialog.getRadioButton);
//Number of images before and after surface
sb=Dialog.getNumber();
sa=Dialog.getNumber();
//Fraction of testing window to main window
tw=Dialog.getNumber();
//Surface detection tolerance
dt=Dialog.getNumber();
//Default surface
selsur=Dialog.getRadioButton();
//Show masks
sm=Dialog.getCheckbox();
//Extract interior
in=Dialog.getCheckbox();
//Auto levels
al=Dialog.getCheckbox();


Stack.setChannel(mch);
print(mch);

ot=getTitle();
//print(ot);
ft=split(ot, nd);
it=ft[0];
print(it);

//testing windows dimmensions
ww=round(iw*tw);
wh=round(ih*tw);

//mask
mw=iw-ww-1;
mh=ih-wh-1;

setBatchMode("hide");

//Create mask image with slice number, where mask surface was detected
newImage("mask", "8-bit black", iw, ih, 1);
imm=getImageID();
setColor(0);
if(selsur=="last"){
	setColor(ns);
}
floodFill(1, 1);


for (i = 1; i <= mw; i++) {
//for (i = 300; i <= 600; i++) {
	print(i);
	for (j = 1; j <= mh; j++) {
		selectImage(im);
		//Stack.setChannel(mch);
		makeRectangle(i, j, ww+1, wh+1);
		si=newArray(ns);
		si_grad=newArray(ns-1);
		for (s = 1; s <= ns; s++) {
    		//Stack.setSlice(s);
    		Stack.setPosition(mch, s, 1);
    		getStatistics(area,mean);
    		//print(mean);
			si[s-1]=mean;
		}
		Array.getStatistics(si, min, max);
		med=0.3*(max-min)/2 + min;
		for (s=0; s<si_grad.length; s++){
      		si_grad[s]=si[s+1]-si[s];
      		}
		fm=Array.findMaxima(si_grad, dt);
		if(fm.length>0){
		selectImage(imm);
		setColor(fm[0]);
		fillRect(i, j, ww+1, wh+1);
		j=j+wh;
		}
		
	}
	i=i+ww;
}


//Save mask and perform bluring (1/4 of testing window)
selectImage(imm);
saveAs("tiff",outdir+it+"-mask_no_blur.tiff");
run("Gaussian Blur...", "sigma="+ww/4);
saveAs("tiff",outdir+it+"-mask.tiff");

//Only for debugging
//setBatchMode("exit and display");
//iw=1200;
//ih=1200;
//ns=85;
//nc=2;
//imm=getImageID();
//sa=3;
//sb=3;
//outdir="/media/standa/5A25-ED95/spinning/2022_12_08/";
//it="ToiM6";
//ot="ToiM6_w1sdc561.stk"


//SURFACE
//Create 3D mask for selection of surface/interior regions
newImage("3D-mask", "8-bit composite-mode", iw, ih, 1, ns, 1);
tdm=getImageID();
for (s = 1; s <= ns; s++) {
	selectImage(imm);
	run("Duplicate...", " ");
	s0=s-sb;
	s1=s+sa;
	if(s0<1){
		s0=1;			
	}
	if(s1>ns){
		s1=ns;
	}
	setThreshold(s0, s1);
	setOption("BlackBackground", true);
	run("Convert to Mask");
	run("Select All");
	run("Copy");
	close();
	selectImage(tdm);
	setSlice(s);
	run("Paste");
}
run("Divide...", "value=255 stack");
if(nc==1) run("Merge Channels...", "c1=3D-mask create keep");
if(nc==2) run("Merge Channels...", "c1=3D-mask c2=3D-mask create keep");
if(nc==3) run("Merge Channels...", "c1=3D-mask c2=3D-mask c3=3D-mask create keep");
if(nc==4) run("Merge Channels...", "c1=3D-mask c2=3D-mask c3=3D-mask c4=3D-mask create keep");
if(nc==5) run("Merge Channels...", "c1=3D-mask c2=3D-mask c3=3D-mask c4=3D-mask c5=3D-mask create keep");
rename("4D-mask");
close("3D-mask");
imageCalculator("Multiply create stack", ot,"4D-mask");
run("Z Project...", "projection=[Max Intensity]");
ri=getImageID();
if(al) {
	for (c = 1; c <= nSlices; c++) {
    setSlice(c);
    run("Enhance Contrast", "saturated=0.20");
	}
}
saveAs("Tiff", outdir+it+"-surface.tiff");
if(!sm) close("Result *");
close("4D-mask");

if(in){
//INTERIOR
//Create 3D mask for selection of surface/interior regions
newImage("3D-mask", "8-bit composite-mode", iw, ih, 1, ns, 1);
tdm=getImageID();
for (s = 1; s <= ns; s++) {
	selectImage(imm);
	run("Duplicate...", " ");
	s1=s+sa+1;
	if(s1>ns){
		s1=ns;
	}
	setThreshold(0, s1);
	setOption("BlackBackground", true);
	run("Convert to Mask");
	run("Select All");
	run("Copy");
	close();
	selectImage(tdm);
	setSlice(s);
	run("Paste");
}
run("Divide...", "value=255 stack");
if(nc==1) run("Merge Channels...", "c1=3D-mask create keep");
if(nc==2) run("Merge Channels...", "c1=3D-mask c2=3D-mask create keep");
if(nc==3) run("Merge Channels...", "c1=3D-mask c2=3D-mask c3=3D-mask create keep");
if(nc==4) run("Merge Channels...", "c1=3D-mask c2=3D-mask c3=3D-mask c4=3D-mask create keep");
if(nc==5) run("Merge Channels...", "c1=3D-mask c2=3D-mask c3=3D-mask c4=3D-mask c5=3D-mask create keep");
rename("4D-mask");
close("3D-mask");
imageCalculator("Multiply create stack", ot,"4D-mask");
run("Z Project...", "projection=[Max Intensity]");
if(al) {
	for (c = 1; c <= nSlices; c++) {
    setSlice(c);
    run("Enhance Contrast", "saturated=0.20");
	}
}
saveAs("Tiff", outdir+it+"-interior.tiff");
close("4D-mask");
if(!sm) close("Result *");
}

if(!sm) close(it+"-mask.tiff");
setBatchMode("exit and display");

}
