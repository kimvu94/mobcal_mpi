#!/bin/sh
 ls *.mfj > mobfit.in 
 input="mobfit.in"
 suffix=".mfj"
 cnt=0
 one=1
 while IFS= read -r var
 do
  inp=${var%$suffix}
  echo "$inp" > temp.in
  tail -n +2 $var >> temp.in
  cp temp.in $var
  rm temp.in
  echo "$inp.mfj" > mobcal.run
  echo "$inp.mout" >> mobcal.run
  mobinp="mobcal.run_$cnt"
  cp mobcal.run $mobinp
  runfile="runit_$cnt"
  echo "#!/bin/bash" > $runfile
  echo "#SBATCH --job-name=mobcal" >> $runfile
  echo "#SBATCH --nodes=1" >> $runfile
  echo "#SBATCH --ntasks-per-node=28" >> $runfile
  echo "#SBATCH --mem=100G" >> $runfile
  echo "#SBATCH --time=02:00:00" >> $runfile
  echo "#SBATCH --chdir=/mmfs1/gscratch/chem/jiahaow/MobCal_MPI_test" >> $runfile
  echo "#SBATCH --partition=compute" >> $runfile
  echo "#SBATCH --account=stf" >> $runfile
  echo "#set up time" >> $runfile
  echo "begin=$(date +%s)" >> $runfile
  echo "module load gnu/parallel/20210422" >> $runfile
  echo "mpirun MobCal_MPI_201.exe $mobinp" >> $runfile
  echo "end=$(date +%s)" >> $runfile
  sbatch $runfile
  sleep 0.5s
  cnt=$(($cnt+$one))
 done < "$input"
