local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local graphPanel = grafana.graphPanel;
local prometheus = grafana.prometheus;

local TITLE = '[NODES] System metrics';

local GRID = import 'graflib/grid.libsonnet';
local NEBULA = import  'graflib/nebula.libsonnet';

// Prometheus filters
local ONLY_NODES='instance=~"nebula-node.*"';
local FILTER_ON_TEMPLATES='%s,instance=~"^$node$"' % ONLY_NODES;

local NODES_DATA_ETH0='instance=~"nebula-node0[45].*",instance=~"^$node$"'; // Nodes that have DATA network on eth0
local NODES_DATA_ETH1='instance=~"nebula-node0[123].*",instance=~"^$node$"'; // Nodes that have DATA network on eth1

// All Prometheus queries
local PROM_CPU_USER=
  'sum(rate(
    node_cpu_seconds_total
    { mode!="idle", mode!="iowait", mode!="system", %s }
    [5m])) BY (instance)' % FILTER_ON_TEMPLATES;

local PROM_CPU_IOWAIT=
  'sum(rate(
    node_cpu_seconds_total
    { mode="iowait", %s }
    [5m])) BY (instance)' % FILTER_ON_TEMPLATES;

local PROM_CPU_SYSTEM=
  'sum(rate(
    node_cpu_seconds_total
    { mode="system", %s }
    [5m])) BY (instance)' % FILTER_ON_TEMPLATES;

local PROM_LOAD=
  'sum(node_load1{ %s }) by (instance)
  / count(node_cpu_seconds_total{mode="system"}) by (instance)' % FILTER_ON_TEMPLATES;

local PROM_MEMORY=
  "1 - sum(node_memory_MemAvailable_bytes { %s }) by (instance) / sum(node_memory_MemTotal_bytes) by (instance)" % FILTER_ON_TEMPLATES;

local PROM_DISK_NODEFS=
  '100 * (node_filesystem_size_bytes{ %s } - node_filesystem_free_bytes) / node_filesystem_size_bytes{mountpoint="/var"}' % FILTER_ON_TEMPLATES;

local PROM_DISK_IMAGEFS=
  '100 * (node_filesystem_size_bytes{ %s } - node_filesystem_free_bytes) / node_filesystem_size_bytes{mountpoint="/var/lib/docker"}' % FILTER_ON_TEMPLATES;

local PROM_NETWORK_RECEIVE='sum(rate(node_network_receive_%s_total{ device="%s", %s }[5m])) by (instance)';
local PROM_NETWORK_TRANSMIT='-sum(rate(node_network_transmit_%s_total{ device="%s", %s }[5m])) by (instance)';

// Dashboard definition
dashboard.new(
  uid='nodes_metrics_use',
  tags=['k8s_metrics'],
  title=TITLE,
)
.addLink( NEBULA.k8s_metrics_link )
.addTemplates([ NEBULA.k8s_node_template ])
.addPanels([ 

  GRID.FULL + row.new( title='CPU', showTitle=true ),
      
    GRID.FULL + graphPanel.new( title='User CPU (core)', fill=2, legend_rightSide=true )
      .addTargets([
        prometheus.target(
          expr=PROM_CPU_USER,
          legendFormat='{{instance}}'
        )
      ]),


    GRID.FULL + graphPanel.new( title='IO wait CPU (core)', fill=2, legend_rightSide=true )
      .addTargets([
        prometheus.target(
          expr=PROM_CPU_IOWAIT,
          legendFormat='{{instance}}'
        )
      ]),


    GRID.FULL + graphPanel.new( title='System CPU (core)', fill=2, legend_rightSide=true )
      .addTargets([
        prometheus.target(
          expr=PROM_CPU_SYSTEM,
          legendFormat='{{instance}}'
        )
      ]),


    GRID.FULL + graphPanel.new( title='Load (1m)', fill=2, legend_rightSide=true, formatY1='percentunit' )
      .addTargets([
        prometheus.target(
          expr=PROM_LOAD,
          legendFormat='{{instance}}'
        )
      ]),

  GRID.FULL + row.new( title='Memory', showTitle=true ),
      
    GRID.FULL + graphPanel.new( title='Node memory utilization', fill=2, legend_rightSide=true )
      .addTargets([
        prometheus.target(
          expr=PROM_MEMORY,
          legendFormat='{{instance}}'
        )
      ]),

  GRID.FULL + row.new( title='Disk', showTitle=true ),

    GRID.FULL + graphPanel.new( title='NodeFS utilization (ephemeral space)', fill=2, legend_rightSide=true, format="percent", decimals=0, max=100 )
      .addTargets([
        prometheus.target(
          expr=PROM_DISK_NODEFS,
          legendFormat='{{instance}}'
        )
      ]),

    GRID.FULL + graphPanel.new( title='ImageFS utilization (docker space)', fill=2, legend_rightSide=true, format="percent", decimals=0, max=100 )
      .addTargets([
        prometheus.target(
          expr=PROM_DISK_IMAGEFS,
          legendFormat='{{instance}}'
        )
      ]),

  GRID.FULL + row.new( title='Network', showTitle=true ),
      
    GRID.HALF_1_H2 + graphPanel.new( title='MAIN network throughput (recv / sent)', fill=2, legend_show=false, format='Bps', decimals=0 )
      .addTargets([
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['bytes', 'eth0', NODES_DATA_ETH1] ),
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['bytes', 'eth1', NODES_DATA_ETH0] ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['bytes', 'eth0', NODES_DATA_ETH1] ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['bytes', 'eth1', NODES_DATA_ETH0] ),
      ]),

    GRID.HALF_2_H2 + graphPanel.new( title='DATA (NFS) network throughput (recv / sent)', fill=2, legend_show=false, format='Bps', decimals=0 )
      .addTargets([
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['bytes', 'eth1', NODES_DATA_ETH1] ),
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['bytes', 'eth0', NODES_DATA_ETH0] ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['bytes', 'eth1', NODES_DATA_ETH1] ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['bytes', 'eth0', NODES_DATA_ETH0] ),
      ]),
       
    GRID.HALF_1 + graphPanel.new( title='MAIN network packets (recv / sent)', fill=2, legend_show=false, format='pps' )
      .addTargets([
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['packets', 'eth0', NODES_DATA_ETH1] ),
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['packets', 'eth1', NODES_DATA_ETH0] ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['packets', 'eth0', NODES_DATA_ETH1] ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['packets', 'eth1', NODES_DATA_ETH0] ),
      ]),

    GRID.HALF_2 + graphPanel.new( title='DATA (NFS) network packets (recv / sent)', fill=2, legend_show=false, format='pps' )
      .addTargets([
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['packets', 'eth1', NODES_DATA_ETH1] ),
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['packets', 'eth0', NODES_DATA_ETH0] ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['packets', 'eth1', NODES_DATA_ETH1] ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['packets', 'eth0', NODES_DATA_ETH0] ),
      ]),
       
    GRID.HALF_1 + graphPanel.new( title='MAIN network drops (recv / sent) per minutes', fill=2, legend_show=false, format='ppm' )
      .addTargets([
        prometheus.target( expr='60*'+PROM_NETWORK_RECEIVE % ['drop', 'eth0', NODES_DATA_ETH1] ),
        prometheus.target( expr='60*'+PROM_NETWORK_RECEIVE % ['drop', 'eth1', NODES_DATA_ETH0] ),
        prometheus.target( expr='60*'+PROM_NETWORK_TRANSMIT % ['drop', 'eth0', NODES_DATA_ETH1] ),
        prometheus.target( expr='60*'+PROM_NETWORK_TRANSMIT % ['drop', 'eth1', NODES_DATA_ETH0] ),
      ]),

    GRID.HALF_2 + graphPanel.new( title='DATA (NFS) network drops (recv / sent) per minutes', fill=2, legend_show=false, format='ppm' )
      .addTargets([
        prometheus.target( expr='60*'+PROM_NETWORK_RECEIVE % ['drop', 'eth1', NODES_DATA_ETH1] ),
        prometheus.target( expr='60*'+PROM_NETWORK_RECEIVE % ['drop', 'eth0', NODES_DATA_ETH0] ),
        prometheus.target( expr='60*'+PROM_NETWORK_TRANSMIT % ['drop', 'eth1', NODES_DATA_ETH1] ),
        prometheus.target( expr='60*'+PROM_NETWORK_TRANSMIT % ['drop', 'eth0', NODES_DATA_ETH0] ),
      ]),
       
    GRID.HALF_1 + graphPanel.new( title='MAIN network errors (recv / sent)', fill=2, legend_show=false, format='pps' )
      .addTargets([
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['errs', 'eth0', NODES_DATA_ETH1] ),
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['errs', 'eth1', NODES_DATA_ETH0] ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['errs', 'eth0', NODES_DATA_ETH1] ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['errs', 'eth1', NODES_DATA_ETH0] ),
      ]),

    GRID.HALF_2 + graphPanel.new( title='DATA (NFS) network errors (recv / sent)', fill=2, legend_show=false, format='pps' )
      .addTargets([
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['errs', 'eth1', NODES_DATA_ETH1] ),
        prometheus.target( expr=PROM_NETWORK_RECEIVE % ['errs', 'eth0', NODES_DATA_ETH0] ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['errs', 'eth1', NODES_DATA_ETH1] ),
        prometheus.target( expr=PROM_NETWORK_TRANSMIT % ['errs', 'eth0', NODES_DATA_ETH0] ),
      ]),
])