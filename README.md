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
- node_exporter: Collects host stats. This needs to be running on each host
- smartmon_collector: Collects disk stats using S.M.A.R.T

**NOTE:** node_exporter and smartmon_collector are not run as docker container. They are run as system services

## Prerequisite 
- docker
- docker-compose

Follow this guide if you have to install docker and docker-compose: https://github.com/thundermagic/rpi_media_centre/blob/master/docs/docker_install.md

## Usage
#### Installing node_exporter
_Skip this if you are not monitoring the host_

**Note: Steps taken from https://devopscube.com/monitor-linux-servers-prometheus-node-exporter/. I have modified it for 
raspberry Pi**  

1.) Download the latest `armv7` version from https://github.com/prometheus/node_exporter/releases. At the time of 
writing, the latest version is `0.18.1`. If you are running this on a different platform, then download the relevant 
platform package
```bash
wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-armv7.tar.gz
```

2.) Unpack the tarball
```bash
tar -xvf node_exporter-0.18.1.linux-armv7.tar.gz
```

3.) Move the node_exporter script to `/usr/local/bin/`
```bash
cd node_exporter-0.18.1.linux-armv7
mv node_exporter /usr/local/bin/
```

4.) Create a user `node_exporter` that will be used to run the node_exporter service. If you want to use a different user, 
then change the user in the `systemd_service_samples/node_exporter.service` file.
```bash
sudo useradd -rs /bin/false node_exporter
```

5.) Open `systemd_service_samples/node_exporter.service` with a text editor and modify it if needed. Comments in the file 
guide you what to modify.

6.) Copy the service file to `/etc/systemd/system`
```bash
cp systemd_service_samples/node_exporter.service /etc/systemd/system/
```

7.) Start and enable the service
```bash
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
```

8.) You should see the stats at `http://<Host-IP>:9100/metrics`

#### Monitoring disk stats
_Skip this step if you are not monitoring disk using S.M.A.R.T_

You need `smartmontools` installed on the host to use this. To install it, `sudo apt install smartmontools`

This uses a script to get disk stats using smartmontools and writes the stats to a file. Node exporter then parse
the file and exposes the stats. 
The script (`smartmon.sh`) is available at: https://github.com/prometheus-community/node-exporter-textfile-collector-scripts.  
A copy of it is in the `textfile_collectors` directory. If there is a newer version of the this script available, then you can
replace it with the newer version in the same directory.

1.) Open `textfile_collectors/run_smartmon.sh` with a text editor and modify it. Comments in the file guide with modifying

2.) Run this as a service
```bash
cp systemd_service_samples/smartmon_collector.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl start smartmon_collector
sudo systemctl enable smartmon_collector
```

You should now have disk stats being written to a file and you should see those stats at `http://<Host-IP>:9100/metrics`

#### Running prometheus

1.) Create directory structure like below to store prometheus and grafana data. I have my external hard disk mounted at /mnt/media.
You can change it to whatever you like. You would need to change the `docker-compose.yaml` file accordingly as well.
```bash
/mnt/media/appdata  
    ├── grafana
    └── prometheus
```

2.) Open `docker-compose.yaml` with a text editor and modify it. Comments in the file guide with modifying

3.) Edit `monitoring_config/prometheus.yml` file as per your setup.

4.) Run the service
```bash
docker-compose up -d
```

5.) Check containers are running
```bash
docker container ls -a
```
All the containers should show as running. If there is any container stuck in a reboot a cycle, check the directory 
structure created in previous steps and check container logs for more info.

##### How do I check container logs?
```bash
docker container logs <container_name>
```
Example, if you have to check logs for prometheus
```bash
docker container logs prometheus
```

If you have to follow/tail logs use the `-f` flag, example;
```bash
docker container logs -f prometheus
```

Assuming everything went alright, you should have all the servics running now.  
You can now access each of the services.

## Accessing services
Assuming your IP address is 192.168.4.4

- Prometheus: http://192.168.4.4:9090
- Grafana: http://192.168.4.4:3000
- Blackbox exporter: http://192.168.4.4:9115
- rpi_cpu_stats: http://192.168.4.4:9669

All the port numbers are listed in the `docker container ls` command under `PORTS` column

Now you should be able to start building your grafana dashboard. There are dashboard already build, you can just import them 
and modify them as per your need


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
Collects hosts stats. This needs to run on each host.  
Website and documentation: https://github.com/prometheus/node_exporter

#### smartmon_collector:
Collects disk stats. It is a node exporter text file exporter
Website and documentation: https://github.com/prometheus-community/node-exporter-textfile-collector-scripts

## How to upgrade a service?
When there is a new version of service available, like a newer grafana version, you can follow these steps to upgrade

_**A bit of a side note regarding docker image tags:** Docker images naming conventions is `<image name>:<tag>`. Usually 
images have a `latest` tag that would be pointing to the latest version of the image. In addition to this images could 
have a tag for specific versions. Check out documentation for the image to know which tags are supported._

Assuming all the services have docker tag of `latest`, to upgrade;

`cd` into the directory where docker-compose file is.  
#### To upgrade all services
```bash
docker-compose pull
docker-compose down
docker-compose up -d
```

#### To upgrade one specific service
Taking example of the grafana service which is using the container name of `grafana`
```bash
docker-compose pull grafana
docker container stop grafana
docker container rm grafana
docker-compose up -d grafana
```

If a service is using specific tag, then you would need to need to change the `docker-compose.yaml` file and change the
tag to the newer tag.  
For example, assuming we have a tag of `v2` available for a service (lets call the service as `srv1` which uses the
 same name as container name)  that currently is using the tag `v1`.   
Change the tag for the image used by this service to `v2` from `v1` and then run below commands in the shell. You have
to be in the directory which have `docker-compose.yaml` file, unless you want to use the `-f` flag with `docker-compose` command.  
```bash
docker-compose pull srv1
docker container stop srv1
docker container rm srv1
docker-compose up -d srv1
``` 