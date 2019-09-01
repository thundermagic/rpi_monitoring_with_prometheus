# Monitoring RPi with Prometheus
Just a bunch of docker services to monitor your Raspberry Pi using prometheus and grafana. It can be used to 
monitor other platforms as well

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