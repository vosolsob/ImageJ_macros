//qsub -X -I -l select=1:ncpus=2:mem=4gb -l walltime=1:00:00
//dir="D:\DATA\Standa\2022_07_19";

dir = getDirectory("Choose a Directory ");
list = getFileList(dir);

//print(list[50]);
for (i=0; i<list.length; i++) {
	if (endsWith(list[i], ".stk")){
		print(list[i]);
		open(dir+"/"+list[i]);
		im=getTitle();
		run("Z Project...", "projection=[Max Intensity]");
		save(dir+list[i]+".tiff");
		close("*"+im);
	}
}


