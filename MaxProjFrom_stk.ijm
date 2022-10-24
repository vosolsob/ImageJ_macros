//  HOW TO RUN ON PC CLUSTER (example):
//    ssh -X vosolsob@elmo.elixir-czech.cz
//    qsub -X -I -l select=1:ncpus=2:mem=4gb -l walltime=1:00:00
//    module load jdk-7 
//    wd="/auto/brno2/home/vosolsob/ImageJ"
//    /storage/brno2/home/vosolsob/Fiji.app/ImageJ-linux64 --headless -macro ${wd}/MaxProjFrom_stk.ijm

// FOR INTERACTIVE DIRECTORY SELECTION
dir = getDirectory("Choose a Directory ");
list = getFileList(dir);

for (i=0; i<list.length; i++) {
	// EDIT PATTERN IF USEFUL
	if (endsWith(list[i], ".stk")){
		print(list[i]);
		open(dir+"/"+list[i]);
		im=getTitle();
		run("Z Project...", "projection=[Max Intensity]");
		save(dir+list[i]+".tiff");
		close("*"+im);
	}
}


