FROM ubuntu:14.04
MAINTAINER <marcos cano jmarcos.cano@gmail.com>

## INSTALL OLSR
RUN apt-get update 
RUN apt-get install -y iperf olsrd 
RUN apt-get install -y git-core 
RUN apt-get install -y make
RUN  apt-get update 
RUN apt-get install -y build-essential supervisor  gcc

## SINTALL BMX6
RUN git clone git://qmp.cat/bmx6.git
RUN cd bmx6 && make && make install


ADD supervisor/supervisord.conf /etc/supervisor/supervisord.conf
ADD supervisor/programs.conf /etc/supervisor/conf.d/programs.conf

CMD [supervisord -c /etc/supervisor/supervisord.conf -n ]


#CMD ["-t", "BMX6"] 

#./bmx6 debug=0 dev=eth0
# olsrd -f /etc/olsrd/olsrd.conf -i eth0 -nofork
