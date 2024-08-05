
# n_tests=(64 100 128 200 256 512 600 900 1024 2000 2048)
n_tests=(64 100 128)

function metric_1() {

    ### Metric 1 - Time
    echo "Metric Time started"

    # Reset file
    echo "" > ./$directory/time.dat
    
    # Start the test
    for i in "${n_tests[@]}"
    do
        ./matmult $i >> ./$directory/time.dat
        echo "$i done"
    done

    echo "Metric Time done"
}


function metric_2(){
    ### Metric 2 - FLOPS
    echo "Metric Memory bandwidth [MBytes/s] started"

    # Reset file
    echo "" > ./$directory/memband.dat

    # DINF?
    CPU=3

    # Run the test
    for i in "${n_tests[@]}"
    do
        likwid-perfctr -C ${CPU} -g L3 -m ./matmult $i | grep "L3 bandwidth" | python3 python_helper.py $i  >> ./$directory/memband.dat
        echo "$i done"
    done
}



function metric_3(){
    ### Metric 2 - FLOPS
    echo "Metric Cache miss L2 started"

    # Reset file
    echo "" > ./$directory/cachemiss.dat

    # DINF?
    CPU=3

    # Run the test
    for i in "${n_tests[@]}"
    do
        likwid-perfctr -C ${CPU} -g L2CACHE -m ./matmult $i | grep "L2 miss ratio" | python3 python_helper.py $i  >> ./$directory/cachemiss.dat
        echo "$i done"
    done
}










# Clears
make purge

# Create output dir
directory="./outputs"

# Check if the directory does not exist
if [ ! -d "$directory" ]; then
    echo "Creating directory: $directory"
    mkdir -p "$directory"
fi


# Global Config
LIKWID_HOME=/home/soft/likwid


# Compile
make

# Freq Fixed
echo "performance" > /sys/devices/system/cpu/cpufreq/policy3/scaling_governor

# Topology log
echo likwid-topology -g -c > processor_arch_doc.txt

# If first argument is 1, run metric 1
if [ $1 -eq 1 ]; then
    metric_1
elif [ $1 -eq 2 ]; then
    metric_2
elif [ $1 -eq 3 ]; then
    metric_3
else
    echo "Invalid argument"
fi

# stop
exit 0









# Restore the original value
echo "powersave" > /sys/devices/system/cpu/cpufreq/policy3/scaling_governor