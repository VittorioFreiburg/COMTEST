# PI UKLFR

[![license - apache 2.0](https://img.shields.io/:license-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Uniklinik Freiburg

Performance indicators for upright stance with moving support surface

## Purposes

Provides PIs for testing upright stance as specified in [x]

## Installation

## Usage

The script `run_pi` launches this PI from the shell of a machine with octave installed.
The permissions of this file must be changed in order to be executable:

```console
chmod 755 run_pi
```

Assuming folder `./test_data/input/` contains the input data, and that `./test_data/output` exists and will contain the resulting files, the shell command is:

```console
./run_pi ./test_data/input/subject_10_trial_01.csv ./test_data/input/subject_10_anthropometry.yaml ./test_data/output
```

At this moment the script accepts two arguments (not less, not more).

## Build docker image

Run the following command in order to create the docker image for this PI:

```console
docker build . -t pi_csic_docker_image
```

## Launch the docker image

Assuming the `test_data/input/` contains the input data, and that the directory `test_data/output/` is created, and will contain the PI output:

```shell
docker run --rm -v $PWD/test_data/input:/in -v $PWD/test_data/output:/out pi_csic_docker_image ./run_pi /in/subject_10_trial_01.csv /in/subject_10_anthropometry.yaml /out
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
