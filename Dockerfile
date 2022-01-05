FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install -y less \
    && apt-get install -y wget \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean
# prepare for launching the installation of dependencies defined in install.sh


# create user account, and create user home dir
RUN useradd -ms /bin/bash comtest
RUN apt-get update \
    && apt-get install -y build-essential \
    && apt-get install -y software-properties-common \
    && apt-get install -y octave \
    && apt-get install -y liboctave-dev

# cp all code files into user home dir

ADD ANALYSIS/OCTAVE/src /home/comtest/src
ADD ANALYSIS/OCTAVE/run_pi_RC /home/comtest/
ADD ANALYSIS/OCTAVE/run_pi_PRTS /home/comtest/
ADD ANALYSIS/OCTAVE/run_pi_SIN /home/comtest/

# set the user as owner of the copied files.
RUN chown -R comtest:comtest /home/comtest/

USER comtest
WORKDIR /home/comtest
