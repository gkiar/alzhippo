#!/bin/bash
#SBATCH --account=rpp-aevans-ab
#SBATCH --time=00:10:00
#SBATCH --mem=4096

scriptpath=/usr/local/lib/python2.7/dist-packages/ndmg/scripts/multigraph_pipeline.py
labs=/project/6008063/gkiar/ndmg/connectomics/atlases/labels/
singpath=~/tools/ndmg/bids-ndmg.simg
dpath=`echo ${1} | rev | cut -f 3- -d "/" | rev`
fname=`echo ${1} | rev | cut -f 1 -d "/" | rev`
labels='/labels/dilated_hipp_parcellation_gspace.nii.gz'

singularity exec -B ${labs}:/labels/ -B ${dpath}:/data/ ${singpath} python ${scriptpath} /data/fibers/${fname} /data/ ${labels}
