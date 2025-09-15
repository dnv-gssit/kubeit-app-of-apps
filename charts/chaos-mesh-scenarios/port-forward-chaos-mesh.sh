#!/bin/bash
set -e

kubectl -n chaos-mesh port-forward svc/chaos-dashboard 2333
