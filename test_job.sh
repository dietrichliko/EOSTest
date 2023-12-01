#!/bin/bash -x
#SBATCH --job-name=EOSTest
#SBATCH --output=EOSTest_%A_%a.out
#SBATCH --array=0-14
#SBATCH --time=06:00:00


readonly SCRIPT_DIR="/users/dietrich.liko/working/SDV/CMSSW_10_6_27/src/EOSTest"
readonly CONFIG="/users/dietrich.liko/working/SDV/CMSSW_10_6_27/src/SoftDisplacedVertices/CustomMiniAOD/test_cfg/MC_UL18_CustomMiniAOD.py"
readarray -t FILES < "$SCRIPT_DIR/files.txt"
readonly WORKAREA="/scratch-cbe/users/$USER/EOSTest/${SLURM_ARRAY_JOB_ID}/${SLURM_ARRAY_TASK_ID}"

mkdir -p "$WORKAREA"
cd "$WORKAREA"

IFS=,
cmsRun "$CONFIG" \
   inputFiles="${FILES[*]:$((SLURM_ARRAY_TASK_ID*5)):5}" \
   outputFile="CustomMiniAOD.root"

mv CustomMiniAOD.root "../CustomMiniAOD_${SLURM_ARRAY_TASK_ID}.root"
