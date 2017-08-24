#!/bin/bash
#Adapted from http://blog.phymata.com/2017/05/13/run-once-daemonset-on-kubernetes/

set -euo pipefail

function main() {
  kubectl apply -f cni-plugin-builder.yaml
  wait_for_pods cni-plugin-builder
  wait_for_build cni-plugin-builder
  kubectl delete -f cni-plugin-builder.yaml
}

function wait_for_pods() {
  echo -n "waiting for $1 pods to run"

  PODS=$(kubectl get pods | grep $1 | awk '{print $1}')

  for POD in ${PODS}; do
    while [[ $(kubectl get pod ${POD} -o go-template --template "{{.status.phase}}") != "Running" ]]; do
      sleep 1
      echo -n "."
    done
  done

  echo
}

function wait_for_build() {
  echo -n "waiting for $1 daemonset to complete"

  PODS=$(kubectl get pods | grep $1 | awk '{print $1}')

  for POD in ${PODS}; do
    while [[ $(kubectl logs ${POD} --tail 1) != "daemondone" ]]; do
      sleep 1
      echo -n "."
    done

    # at this point you could take the output of kubectl logs and do something with it
  done

  echo
}

main
