// This example macro tool creates circular selections.
// Press ctrl-i (Macros>Install Macros) to reinstall after
// making changes. Double click on the tool icon (a circle)
// to set the radius of the circle.
// There is more information about macro tools at
//   http://imagej.nih.gov/ij/developer/macro/macros.html#tools
// and many more examples at
//   http://imagej.nih.gov/ij/macros/tools/

var radius = 6;
var x1=-1;
var x2=-1;
var y1=-1;
var y2=-1;
var z1=-1;
var z2=-1;
//voxel size
var pw=1;
var ph=1;
var pd=1;
var tissue="unknown";
var i=0;



//macro "Circle Tool - C00cO11cc" {
//   getCursorLoc(x, y, z, flags);
//   makeOval(x-radius, y-radius, radius*2, radius*2);
//}

//macro "Anther axis Tool Options" {
//      sack = getNumber("Pollen sack id (1 or 2): ", sack);
//}


macro "Chloroplast signal Tool - Cf00o11ee" {
      leftButton=16;
      rightButton=4;
      shift=1;
      ctrl=2; 
      alt=8;
      x2=-1; y2=-1; z2=-1; flags2=-1;
      tissue="chloroplast";
      getCursorLoc(x1, y1, z1, flags);
      while (flags&leftButton!=0) {
          getCursorLoc(x1, y1, z1, flags);
          makeOval(x1-radius, y1-radius, radius*2, radius*2);
          //makePoint(x1, y1, "extra large red dot");
          Overlay.addSelection("red");
          
          //roiManager("add & draw");
          //roiManager("add");
          if (x1!=x2 || y1!=y2 || z1!=z2) {
              s = " ";
              if (flags&leftButton!=0) s = s + "<left>";
              if (flags&rightButton!=0) s = s + "<right>";
              if (flags&shift!=0) s = s + "<shift>";
              if (flags&ctrl!=0) s = s + "<ctrl> ";
              if (flags&alt!=0) s = s + "<alt>";
              saveData();
              print(i);
              print(x1+" "+y1+" "+z1+" "+flags + "" + s);
              logOpened = true;
              startTime = getTime();
          }
          x2=x1; y2=y1; z2=z1; flags2=flags;
          wait(10);
      }
 }


macro "Membrane signal Tool - Cff0o11ee" {
      leftButton=16;
      rightButton=4;
      shift=1;
      ctrl=2; 
      alt=8;
      x2=-1; y2=-1; z2=-1; flags2=-1;
      tissue="membrane";
      getCursorLoc(x1, y1, z1, flags);
      while (flags&leftButton!=0) {
          getCursorLoc(x1, y1, z1, flags);
          makeOval(x1-radius, y1-radius, radius*2, radius*2);
          //makePoint(x1, y1, "extra large yellow dot");
          Overlay.addSelection("yellow");
          //roiManager("add & draw");
          //roiManager("add");
          if (x1!=x2 || y1!=y2 || z1!=z2) {
              s = " ";
              if (flags&leftButton!=0) s = s + "<left>";
              if (flags&rightButton!=0) s = s + "<right>";
              if (flags&shift!=0) s = s + "<shift>";
              if (flags&ctrl!=0) s = s + "<ctrl> ";
              if (flags&alt!=0) s = s + "<alt>";
              saveData();
              print(i);
              print(x1+" "+y1+" "+z1+" "+flags + "" + s);
              logOpened = true;
              startTime = getTime();
          }
          x2=x1; y2=y1; z2=z1; flags2=flags;
          wait(10);
      }
 }
 



macro "Background Tool - C666o11ee" {
      leftButton=16;
      rightButton=4;
      shift=1;
      ctrl=2; 
      alt=8;
      x2=-1; y2=-1; z2=-1; flags2=-1;
      tissue="background";
      getCursorLoc(x1, y1, z1, flags);
      while (flags&leftButton!=0) {
          getCursorLoc(x1, y1, z1, flags);
          makeOval(x1-radius, y1-radius, radius*2, radius*2);
          //makePoint(x1, y1, "extra large gray dot");
          Overlay.addSelection("gray");
          //roiManager("add & draw");
          //roiManager("add");
          if (x1!=x2 || y1!=y2 || z1!=z2) {
              s = " ";
              if (flags&leftButton!=0) s = s + "<left>";
              if (flags&rightButton!=0) s = s + "<right>";
              if (flags&shift!=0) s = s + "<shift>";
              if (flags&ctrl!=0) s = s + "<ctrl> ";
              if (flags&alt!=0) s = s + "<alt>";
              saveData();
              print(i);
              print(x1+" "+y1+" "+z1+" "+flags + "" + s);
              logOpened = true;
              startTime = getTime();
          }
          x2=x1; y2=y1; z2=z1; flags2=flags;
          wait(10);
      }
 }



function saveData() {
	bandWidth = 0;
	Begin = 0;
	End = 0;
	Step = 0;
	//Get parameters of lambdaScan
	a=split(getInfo("image.title"),"( - )");
	//print(a[1]+" Image #0|ATLConfocalSettingDefinition #0|LambdaDefinition #0|LambdaDetectionBandWidth =");
	inf=split(getInfo(), '\n');
	for (i=0; i<inf.length; i++) {
    	if (startsWith(inf[i], a[1]+" Image #0|ATLConfocalSettingDefinition #0|LambdaDefinition #0|LambdaDetectionBandWidth =")) {
        	parts = split(inf[i], "=");
        	bandWidth = parseFloat(String.trim(parts[1]));
        	//print("BandWidth =", bandWidth);
    	}
    	if (startsWith(inf[i], a[1]+" Image #0|ATLConfocalSettingDefinition #0|LambdaDefinition #0|LambdaDetectionBegin =")) {
        	parts = split(inf[i], "=");
        	Begin = parseFloat(String.trim(parts[1]));
        	//print("Begin =", Begin);
    	}
    	if (startsWith(inf[i], a[1]+" Image #0|ATLConfocalSettingDefinition #0|LambdaDefinition #0|LambdaDetectionLastBegin =")) {
        	parts = split(inf[i], "=");
        	End = parseFloat(String.trim(parts[1]));
        	//print("End =", End);
    	}
    	if (startsWith(inf[i], a[1]+" Image #0|ATLConfocalSettingDefinition #0|LambdaDefinition #0|LambdaDetectionStepSize =")) {
        	parts = split(inf[i], "=");
        	Step = parseFloat(String.trim(parts[1]));
        	//print("Step =", Step);
    	}
	}
	//transformace na realné jednotky
	getVoxelSize(pw, ph, pd, unit);
	//Známe X1,Y1... pozice apexu a X2,Y2... pozice báze
	getStatistics(area, mean, min, max, std);
	print(nResults);
	i=nResults;
	setResult("Image", i, a[1]);
	setResult("Structure", i, tissue);
	setResult("X", i, x1);
	setResult("Y", i, y1);
	setResult("Z", i, z1*pd);
	setResult("Area ("+unit+"^2)", i, area);
    setResult("Mean", i, mean);
    setResult("Std", i, std);
    setResult("Min", i, min);
    setResult("Max", i, max);
    setResult("bandWidth", i, bandWidth);
    setResult("Begin", i, Begin);
    setResult("End", i, End);
    setResult("Step", i, Step);
    setResult("Lambda", i, Begin+z1*Step+0.5*bandWidth);
	i=i+1;
}

