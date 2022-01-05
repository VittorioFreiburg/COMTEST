# COMTEST

Code development for the COMTEST project

## Content

* `Analysis`: Tools for the analysis of trials
* `Platform`: Stewart Platform control system
* `Tracking`: Xsense tracking system [doi.org/10.5220/0009869106750680]

## Computing Performance indicators

### Using Octave

**run_pi_RC**: Computes dynamic indexes describing the response to raised cosine stimulus (RC). The indexes are defined along the lines of the response to the step function:

* Rise time
* Settling time
* Overshoot [%]
* Peak time
* max
* min

Under Octave, from the folder `Analysis\Octave`, the command to launch is:

```octave
addpath("src")
computePI_RC('test_data\input\com_RCsway.csv','result.yaml')
```

Under Linux, one can directly use from the terminal the following command (from the same folder, assuming the folder `output` is already created, and that we are located in `ANALYSIS/OCTAVE`):

```term
./run_pi_RC test_data\input\com_RCsway.csv output
```

A file named `output/pi_rcsway.yaml` is created with the Performance indicator values.

**run_pi_PRTS**: Computes frequency response function (FRF) and indexes based on the response to pseudorandom stimulus.

* FRF
* Human likeness score

Under Linux:

```term
./run_pi_PRTS test_data/input/com_PRTS_Sample_np_PF_110208_a1_1_c_z.csv output
```

Files `output/pi_prts_sway.yaml` (Human likeness) and `output\pi_prts_frf.yaml`(FRF) get generated.

**run_pi_SIN**:  indexes based on the response to sinusoidal stimulus.

* Peak to peak gain
* gain
* phase lag
* power (output/input)

Under Linux:

```term
./run_pi_SIN test_data/input/com_SinSample.csv output
```

File `output/pi_sinsway.yaml` gets created.

## Docker-based code access

The following is valid for Linux machines.

### Get official image

An image ready to be used is available, without downloading this code repository:

```console
docker pull eurobenchtest/pi_comtest
```

Now you can jump on the command to launch the docker image.

### Build docker image

Run the following command in order to create the docker image for this testbed, from the repository code:

```console
docker build . -t pi_comtest
```

### Launch the docker image

Assuming the folder `[repo]/ANALYSIS/OCTAVE/test_data/input` contains the input data, and that the directory `out_tests/` is **already created**, and will contain the PI output:

```shell
docker run --rm -v $PWD/ANALYSIS/OCTAVE/test_data/input:/in -v $PWD/out_tests:/out pi_comtest ./run_pi_RC /in/com_RCsway.csv /out
docker run --rm -v $PWD/ANALYSIS/OCTAVE/test_data/input:/in -v $PWD/out_tests:/out pi_comtest ./run_pi_PRTS /in/com_PRTS_Sample_np_PF_110208_a1_1_c_z.csv /out
docker run --rm -v $PWD/ANALYSIS/OCTAVE/test_data/input:/in -v $PWD/out_tests:/out pi_comtest ./run_pi_SIN /in/com_SinSample.csv  /out
```

## Acknowledgements

<a href="http://eurobench2020.eu">
  <img src="http://eurobench2020.eu/wp-content/uploads/2018/06/cropped-logoweb.png"
       alt="rosin_logo" height="60" >
</a>

Supported by Eurobench - the European robotic platform for bipedal locomotion benchmarking.
More information: [Eurobench website][eurobench_website]

<img src="http://eurobench2020.eu/wp-content/uploads/2018/02/euflag.png"
     alt="eu_flag" width="100" align="left" >

This project has received funding from the European Union’s Horizon 2020
research and innovation programme under grant agreement no. 779963.

The opinions and arguments expressed reflect only the author‘s view and
reflect in no way the European Commission‘s opinions.
The European Commission is not responsible for any use that may be made
of the information it contains.

[eurobench_logo]: http://eurobench2020.eu/wp-content/uploads/2018/06/cropped-logoweb.png
[eurobench_website]: http://eurobench2020.eu "Go to website"
