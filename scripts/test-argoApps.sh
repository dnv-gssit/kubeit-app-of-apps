#!/usr/bin/env bash

RUN_PATH=$PWD
SCRIPT_PATH=${SCRIPT_PATH:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}

RENDERED_CHART_PATH=/tmp/rendered_chart

echo "===]> Info: RUN_PATH=$RUN_PATH"
echo "===]> Info: SCRIPT_PATH=$SCRIPT_PATH"

rm -rf $RENDERED_CHART_PATH

rm -rf charts Chart.lock

helm template --dependency-update --render-subchart-notes .  \
  -f $SCRIPT_PATH/test-argoApps.yaml \
  --output-dir $RENDERED_CHART_PATH --debug

yamllint -c $SCRIPT_PATH/../.yamllint -s $RENDERED_CHART_PATH

# code /tmp/rendered_chart/kubeit-app-of-apps-values-chart/templates/applications.yaml
# code /tmp/rendered_chart/kubeit-app-of-apps-values-chart/charts/kubeit-app-of-apps/templates/applications.yaml
