# Monitoring RPi with Prometheus
Just a bunch of docker services to monitor your Raspberry Pi using prometheus and grafana. It can be used to 
monitor other platforms as well

Since this uses docker containers, it can be run on `amd64` platforms as well (i.e your windows or linux machine). 
This guide is generic, any platform specific changes would be highlighted with comments.

## Services used
- Prometheus: Time series database
- Grafana: Visualisation
- Blackbox exporter: To probe things using HTTP, ICMP etc etc, check Internet connectivity
- rpi_cpu_stats: Raspberry Pi CPU temp and freq exporter. You don't need to use this if not using RPi
- node_exporter: Collects host stats
- smartmon_collector: Collects disk stats using S.M.A.R.T

**NOTE:** node_exporter and smartmon_collector are not run as docker container. They are run as system services

## Prerequisite 
- docker
- docker-compose

Follow this guide if you have to install docker and docker-compose: https://github.com/thundermagic/rpi_media_centre/blob/master/docs/docker_install.md

## Services details
#### Prometheus
Time series database.  
Website: https://prometheus.io/  
Docker image: https://hub.docker.com/r/prom/prometheus  
Documentation: https://prometheus.io/docs/introduction/overview/

#### Grafana
Analytics and visualisation.  
Website: https://grafana.com/  
Docker image: https://hub.docker.com/r/grafana/grafana  
Documentation: https://grafana.com/docs/

#### blackbox_exporter
Probing things with HTTP, HTTPS, DNS, TCP and ICMP.  
Website and documentation: https://github.com/prometheus/blackbox_exporter  
Docker image: https://hub.docker.com/r/prom/blackbox-exporter

#### rpi_cpu_stats
Prometheus exporter to expose raspberry pi cpu stats like temp and frequencies. Does not rely on vcgencmd command.  
I use prometheus [node_exporter](https://github.com/prometheus/node_exporter) to monitor the hosts but node exporter was not 
exposing the cpu temperature and cpu frequencies correctly for raspberry pi. So I created this exporter.  
Website: https://github.com/thundermagic/rpi_cpu_stats  
Docker image and documentation: https://hub.docker.com/r/thundermagic/rpi_cpu_stats

#### node_exporter
Collects hosts stats.  
Website and documentation: https://github.com/prometheus/node_exporter

#### smartmon_collector:
Collects disk stats. It is a node exporter text file exporter
Website and documentation: https://github.com/prometheus-community/node-exporter-textfile-collector-scripts 