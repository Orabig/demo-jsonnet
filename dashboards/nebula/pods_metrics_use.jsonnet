local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;
local template = grafana.template;

local TITLE = '[PODS] System metrics';

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
    container_cpu_usage_seconds_total{ container!="POD", container!="" } [5m])) BY (pod)
   * on (pod) group_left(node,namespace) kube_pod_info{%s}' % FILTER_ON_TEMPLATES;

local PROM_MEMORY_USAGE=
  'sum(label_join(container_memory_working_set_bytes{container!="POD", container!=""},"node","","instance")) by (node,pod)
   * on (pod) group_left(node,namespace) kube_pod_info{%s}' % FILTER_ON_TEMPLATES;
local PROM_MEMORY_LIMIT=
  '100 * sum(container_memory_working_set_bytes) by (namespace,pod)
          / sum(kube_pod_container_resource_limits_memory_bytes{%s}) by (namespace,pod)' % FILTER_ON_TEMPLATES;

local PROM_DISK_READ=
  'sum(rate(container_fs_reads_bytes_total{device=~"/dev/sd.*",container!=""}[5m])) by (instance,pod)
          * on (pod) group_left(namespace) kube_pod_info{ %s }' % FILTER_ON_TEMPLATES;
local PROM_DISK_WRITE=
  'sum(rate(container_fs_writes_bytes_total{device=~"/dev/sd.*",container!=""}[5m])) by (instance,pod)
          * on (pod) group_left(namespace) kube_pod_info{ %s }' % FILTER_ON_TEMPLATES;

local PROM_NETWORK_RECEIVE='sum(rate(container_network_receive_%s_total{container="POD",interface="%s",%s}[5m])) by (namespace,pod)
* on (pod) group_left(node,namespace) kube_pod_info{node=~"^$node$",namespace=~"^$namespace$",pod=~"^$pod-.*$"}';
local PROM_NETWORK_TRANSMIT='-sum(rate(container_network_transmit_%s_total{container="POD",interface="%s",%s}[5m])) by (namespace,pod)
* on (pod) group_left(node,namespace) kube_pod_info{node=~"^$node$",namespace=~"^$namespace$",pod=~"^$pod-.*$"}';

// Dashboard definition
dashboard.new(
  uid='pods_metrics_use',
  tags=['k8s_metrics'],
  title=TITLE,
)
.addLink( NEBULA.k8s_metrics_link )
.addTemplates([ NEBULA.k8s_node_template, NEBULA.k8s_namespace_template, NEBULA.k8s_pod_template ])
.addPanels([ 

  row.new( title='CPU', showTitle=true ),
      
    GRID.FULL + graphPanel.new( title='Pod usage CPU (user+system)', fill=2, legend_show=false )
      .addTargets([
        prometheus.target(
          expr=PROM_CPU_USAGE,
          legendFormat='[{{node}}] {{namespace}} : {{pod}}'
        )
      ]),


  row.new( title='Memory', showTitle=true ),
      
    GRID.FULL_H2 + graphPanel.new( title='Pod memory utilization', fill=2, legend_show=false, format='bytes')
      .addTargets([
        prometheus.target(
          expr=PROM_MEMORY_USAGE,
          legendFormat='[{{node}}] {{namespace}} : {{pod}}'
        )
      ]),

    GRID.FULL + graphPanel.new( title='Pod memory (% of limit) - all nodes', fill=2, legend_show=false, format='percent', decimals=0 )
      .addTargets([
        prometheus.target(
          expr=PROM_MEMORY_LIMIT,
          legendFormat='[{{node}}] {{namespace}} : {{pod}}'
        )
      ]),



  row.new( title='Disk', showTitle=true ),

    GRID.FULL + graphPanel.new( title='Local disk read', fill=2, legend_show=false, format='Bps' )
      .addTargets([
        prometheus.target(
          expr=PROM_DISK_READ,
          legendFormat='[{{node}}] {{namespace}} : {{pod}}'
        )
      ]),

    GRID.FULL + graphPanel.new( title='Local disk writes', fill=2, legend_show=false, format='Bps' )
      .addTargets([
        prometheus.target(
          expr=PROM_DISK_WRITE,
          legendFormat='[{{node}}] {{namespace}} : {{pod}}'
        )
      ]),

  row.new( title='Network', showTitle=true ),
      
    GRID.HALF_1_H2 + graphPanel.new( title='MAIN network throughput (recv / -sent)', fill=2, legend_show=false, format='Bps', decimals=0 )
      .addTargets([
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['bytes', 'eth0', NODES_DATA_ETH1] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['bytes', 'eth1', NODES_DATA_ETH0] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['bytes', 'eth0', NODES_DATA_ETH1] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['bytes', 'eth1', NODES_DATA_ETH0] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
      ]),

    GRID.HALF_2_H2 + graphPanel.new( title='DATA (NFS) network throughput (recv / -sent)', fill=2, legend_show=false, format='Bps', decimals=0 )
      .addTargets([
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['bytes', 'eth1', NODES_DATA_ETH1] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['bytes', 'eth0', NODES_DATA_ETH0] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['bytes', 'eth1', NODES_DATA_ETH1] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['bytes', 'eth0', NODES_DATA_ETH0] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
      ]),
       
    GRID.HALF_1 + graphPanel.new( title='MAIN network drops (recv / -sent) per minute', fill=2, legend_show=false, format='ppm' )
      .addTargets([
        prometheus.target( expr='60*'+PROM_NETWORK_RECEIVE % ['packets_dropped', 'eth0', NODES_DATA_ETH1] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr='60*'+PROM_NETWORK_RECEIVE % ['packets_dropped', 'eth1', NODES_DATA_ETH0] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr='60*'+PROM_NETWORK_TRANSMIT % ['packets_dropped', 'eth0', NODES_DATA_ETH1] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr='60*'+PROM_NETWORK_TRANSMIT % ['packets_dropped', 'eth1', NODES_DATA_ETH0] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
      ]),

    GRID.HALF_2 + graphPanel.new( title='DATA (NFS) network drops (recv / -sent) per minute', fill=2, legend_show=false, format='ppm' )
      .addTargets([
        prometheus.target( expr='60*'+PROM_NETWORK_RECEIVE % ['packets_dropped', 'eth1', NODES_DATA_ETH1] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr='60*'+PROM_NETWORK_RECEIVE % ['packets_dropped', 'eth0', NODES_DATA_ETH0] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr='60*'+PROM_NETWORK_TRANSMIT % ['packets_dropped', 'eth1', NODES_DATA_ETH1] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr='60*'+PROM_NETWORK_TRANSMIT % ['packets_dropped', 'eth0', NODES_DATA_ETH0] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
      ]),
       
    GRID.HALF_1 + graphPanel.new( title='MAIN network packets (recv / -sent)', fill=2, legend_show=false, format='pps' )
      .addTargets([
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['packets', 'eth0', NODES_DATA_ETH1] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['packets', 'eth1', NODES_DATA_ETH0] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['packets', 'eth0', NODES_DATA_ETH1] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['packets', 'eth1', NODES_DATA_ETH0] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
      ]),

    GRID.HALF_2 + graphPanel.new( title='DATA (NFS) network packets (recv / -sent)', fill=2, legend_show=false, format='pps' )
      .addTargets([
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['packets', 'eth1', NODES_DATA_ETH1] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['packets', 'eth0', NODES_DATA_ETH0] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['packets', 'eth1', NODES_DATA_ETH1] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['packets', 'eth0', NODES_DATA_ETH0] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
      ]),
       
    GRID.HALF_1 + graphPanel.new( title='MAIN network errors (recv / -sent)', fill=2, legend_show=false, format='pps' )
      .addTargets([
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['errors', 'eth0', NODES_DATA_ETH1] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['errors', 'eth1', NODES_DATA_ETH0] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['errors', 'eth0', NODES_DATA_ETH1] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['errors', 'eth1', NODES_DATA_ETH0] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
      ]),

    GRID.HALF_2 + graphPanel.new( title='DATA (NFS) network errors (recv / -sent)', fill=2, legend_show=false, format='pps' )
      .addTargets([
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['errors', 'eth1', NODES_DATA_ETH1] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['errors', 'eth0', NODES_DATA_ETH0] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['errors', 'eth1', NODES_DATA_ETH1] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['errors', 'eth0', NODES_DATA_ETH0] ,legendFormat='[{{node}}] {{namespace}} : {{pod}}' ),
      ]),



])