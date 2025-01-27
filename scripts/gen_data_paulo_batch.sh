#!/bin/bash
#SBATCH --job-name=perturb            # Job name
#SBATCH --output=perturb_%A_%a.out    # Standard output (%A is the job ID, %a is the array index)
#SBATCH --error=perturb_%A_%a.err     # Standard error (%A is the job ID, %a is the array index)
#SBATCH --ntasks=1                    # Number of tasks (1 for single-task jobs)
#SBATCH --time=20:00:00               # Time limit (hh:mm:ss)
#SBATCH --mem=24G                     # Memory required per node
#SBATCH --gres=gpu:1  #asking for a gpu
#SBATCH --mail-type=FAIL              # Send email if the job fails
#SBATCH --mail-user=paulo.ortizfonseca@donders.ru.nl  # Specify my email to the cluster



#Code from Edward Gerrit 
echo "load cuda module..."
module load cuda
echo
echo "load anaconda module..."s
module load anaconda3

echo
echo "Check loaded modules:"
module list
echo

# Check if CUDA is available

echo "Checking available GPU:"
nvidia-smi
echo

echo "Checkin cuda availability:"
echo "Output of which nvcc to check cuda path:"
which nvcc

echo
echo "Check cuda version with nvcc --version:"

nvcc --version

if [ $? -ne 0 ]; then
    echo "CUDA test failed. Exiting job."
    exit 1
fi

# Check cuda version available from bash

echo "CUDA test passed. Proceeding with main computation."




#loading my conda environment 
#module load cuda
#module load anaconda3 #I am already doing all these things before submitting my job, just to be sure this is the right way
source activate wormholes

#setting the right working directory
cd /project/3018078.01/Gaziv/Wormholes_FB

#adding specific paths for my job to find
export PYTHONPATH=/project/3018078.01/Gaziv/Wormholes_FB/:$PYTHONPATH

#be sure that CUDA is visible (I need CUDA)
#export CUDA_VISIBLE_DEVICES=0 


# Run the CUDA test
#echo "Running CUDA availability test..."
#python scripts/cuda_test.py

# Check if CUDA is available and continue only if the test passes
#if [ $? -ne 0 ]; then
#    echo "CUDA test failed. Exiting job."
#    exit 1
#fi

# echo "CUDA test passed. Proceeding with main computation."


#running the computation script
for j in $(seq 0 100)
do
    echo "Running iteration: $j"
    python -m scripts.gen_data --num $j --batch_size 100 --gen_version $1
done