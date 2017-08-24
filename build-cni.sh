#!/bin/bash
# Adapted from http://blog.phymata.com/2017/05/13/run-once-daemonset-on-kubernetes/
set -euo pipefail

# gracefully handle the TERM signal sent when deleting the daemonset
trap 'exit' TERM

#do the work
git clone https://github.com/containernetworking/plugins.git cni-plugins

cd ./cni-plugins/
./build.sh

cp bin/* /opt/cni/bin/

# let the monitoring script know we're done'
echo "daemondone"

# this is a workaround to prevent the container from exiting
# and k8s restarting the daemonset pod
while true; do sleep 10; done
