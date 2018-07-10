#!/bin/bash

indir=${1}
dset=${2}
parc=${3}
proj=/home/gkiar/projects/rpp-aevans-ab/hippocamp_jvogel/
mkdir -p ${proj}fibers/${dset}

for fl in `ls $indir`; do
	ofl=`echo ${fl} | cut -f 1 -d "."`.trk
	singularity exec -B $indir:/data/ -B ${proj}:/proj/ /home/gkiar/projects/rpp-aevans-ab/utils/scil/singimg.img python2.7 /proj/scripts/npz2trackviz.py /data/${fl} ${3} -o /proj/fibers/${dset}/${ofl}
  # With Docker, this could be:
  # docker run -ti -v ${indir}:/data -v ${proj}:/proj --entrypoint python2.7 bids/ndmg:v0.1.0 /proj/scripts/npz2trackviz.py /data/${fl} ${3}

done
