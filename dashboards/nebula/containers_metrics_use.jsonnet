local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local TITLE = '[CONTAINERS] System metrics';

local GRID = import 'graflib/grid.libsonnet';
local NEBULA = import  'graflib/nebula.libsonnet';

// Prometheus filters
local ONLY_NODES='instance=~"nebula-node.*"';

local NODES_DATA_ETH0='instance=~"nebula-node0[45].*"'; // Nodes that have DATA network on eth0
local NODES_DATA_ETH1='instance=~"nebula-node0[123].*"'; // Nodes that have DATA network on eth1

local FILTER_ON_TEMPLATES='node=~"^$node$",namespace=~"^$namespace$",pod=~"^$pod-.*$"';


// All Prometheus queries
local PROM_CPU_USAGE=
  'sum(rate(
    container_cpu_usage_seconds_total{ container!="POD", container!="" } [5m])) BY (pod,container)
   * on (pod) group_left(node,namespace) kube_pod_info{%s}' % FILTER_ON_TEMPLATES;

local PROM_MEMORY_USAGE=
  'sum(container_memory_working_set_bytes{container!="POD", container!=""}) by (pod,container)
   * on (pod) group_left(node,namespace) kube_pod_info{%s}' % FILTER_ON_TEMPLATES;
local PROM_MEMORY_LIMIT=
  '100 * sum(container_memory_working_set_bytes) by (pod,container_name)
          / sum(label_join(kube_pod_container_resource_limits_memory_bytes{ %s },
            "container_name", "", "container")) by (pod,container_name)' % FILTER_ON_TEMPLATES;

local PROM_DISK_READ=
  'sum(rate(container_fs_reads_bytes_total{device=~"/dev/sd.*",container!=""}[5m])) by (pod,container)
          * on (pod) group_left(namespace) kube_pod_info{ %s }' % FILTER_ON_TEMPLATES;
local PROM_DISK_WRITE=
  'sum(rate(container_fs_writes_bytes_total{device=~"/dev/sd.*",container!=""}[5m])) by (pod,container)
          * on (pod) group_left(namespace) kube_pod_info{ %s }' % FILTER_ON_TEMPLATES;

// Dashboard definition
dashboard.new(
  uid='container_metrics_use',
  tags=['k8s_metrics'],
  title=TITLE,
)
.addLink( NEBULA.k8s_metrics_link )
.addTemplates([ NEBULA.k8s_node_template, NEBULA.k8s_namespace_template, NEBULA.k8s_pod_template ])
.addPanels([ 

  row.new( title='CPU', showTitle=true ),
      
    GRID.FULL + graphPanel.new( title='Container usage CPU (user+system)', fill=2, legend_show=false )
      .addTargets([
        prometheus.target(
          expr=PROM_CPU_USAGE,
          legendFormat='{{pod}} - {{container}}'
        )
      ]),


  row.new( title='Memory', showTitle=true ),
      
    GRID.FULL_H2 + graphPanel.new( title='Container memory utilization', fill=2, legend_show=false, format='bytes')
      .addTargets([
        prometheus.target(
          expr=PROM_MEMORY_USAGE,
          legendFormat='{{pod}} - {{container}}'
        )
      ]),

    GRID.FULL + graphPanel.new( title='Container memory (% of limit) - all nodes', fill=2, legend_show=false, format='percent', decimals=0 )
      .addTargets([
        prometheus.target(
          expr=PROM_MEMORY_LIMIT,
          legendFormat='{{pod}} - {{container}}'
        )
      ]),

])