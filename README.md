# COMTEST

Code development for the COMTEST project

## Content

* `Analysis`: to be defined
* `Platform`: to be defined
* `Tracking`: to be defined.

## Computing Performance indicators

### Using Octave

** run_pi_RC **: _defined what it computes.

Under Octave, from the folder `Analysis\Octave`, the command to launch is:

```octave
addpath("src")
computePI_RC('test_data\input\RCsway.csv','result.yaml')
```

Under Linux, one can directly use from the terminal the following command (from the same folder, assuming the folder `output` is already created):

```term
./run_pi_RC test_data\input\RCsway.csv output
```

A file name `output/pi_rcsway.yaml` is created with the Performance indicator values.


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
