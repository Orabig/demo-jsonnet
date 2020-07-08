local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local singlestat = grafana.singlestat;
local prometheus = grafana.prometheus;
local template = grafana.template;

dashboard.new(
  'JVM',
  schemaVersion=16,
  tags=['java'],
)
.addTemplate(
  template.datasource(
    'PROMETHEUS_DS',
    'prometheus',
    'Prometheus',
    hide='label',
  )
)
.addPanel(
  singlestat.new(
    'uptime',
    format='s',
    datasource='Prometheus',
    span=2,
    valueName='current',
  )
  .addTarget(
    prometheus.target(
      'time() - process_start_time_seconds{env="$env", job="$job", instance="$instance"}',
    )
  ), gridPos={
    x: 0,
    y: 0,
    w: 24,
    h: 3,
  }
)
