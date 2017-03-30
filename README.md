## PLDI'17 Artifact Evaluation

- Title : Taming Undefined Behavior in LLVM

## Running Experiment

- See artifacteval.pdf

### Using cpuset

- `cpuset` is a tool that dedicates specific cores to some performance-critical processes.
- Running experiment with `cpuset` :
    
    (1) Create a new user - our script is tailored to an imaginary user `pldi1717` with password `pldi201717`, who has sudoer's priviledge.
    
    (2) Log in to user `pldi1717`, and extract(or clone) this artifact 
    
    (3) Install `cpuset` by running `install-cpuset.sh`
    
    (4) For each experiment, modify scripts according to `artifacteval.pdf`
    
    (5) Run experiment on user `pldi1717`

- Note : you can't use `cpuset` if your system has only one core.

### Setup For Performance Consistency

- Disable gui and network service
- Disable ASLR : http://askubuntu.com/questions/318315/how-can-i-temporarily-disable-aslr-address-space-layout-randomization
- Disable Intel Hyper-Threading, TurboBoost, Turbo mode, SpeedStep
- Set scaling governor to 'performance' : https://wiki.archlinux.org/index.php/CPU_frequency_scaling
    - `sudo cpupower frequency-set -g performance`
    - Check with `cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor`
- Let benchmark programs fully use your computer's resource.


