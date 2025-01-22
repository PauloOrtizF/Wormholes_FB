#!/bin/bash


#SBATCH --mail-type=FAIL
#SBATCH --job-name=perturb
#SBATCH -o /home/predatt/pauort/slurm_reports/perturb_%N.%A_%a.out
#SBATCH --array=0-100
#SBATCH --time=03:00:00
#SBATCH --ntasks=1
#SBATCH --mem=24G
#SBATCH -N 1 -c 14 --gres=gpu:1 --constraint=24GB

module load anaconda3
source activate wormholes
cd /project/3018078.01/Gaziv/Wormholes_FB
export PYTHONPATH=/project/3018078.01/Gaziv/Wormholes_FB/:$PYTHONPATH
export CUDA_VISIBLE_DEVICES=0

# Via SLURM job array
# echo Gen Version [$1]
# python -m scripts.gen_data --num $SLURM_ARRAY_TASK_ID --batch_size 100 --gen_version $1


# Via for loop
for j in $(seq 0 100)
do
    echo $j
    python -m scripts.gen_data --num $j --batch_size 100 --gen_version $1
done