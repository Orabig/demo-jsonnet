local grafana = import 'grafonnet/grafana.libsonnet';
local link = grafana.link;
local template = grafana.template;

{
    k8s_metrics_link: link.dashboards(title='K8S metrics', tags=['k8s_metrics'],keepTime=true,includeVars=true),

    k8s_node_template: template.new(
            name='node',
            datasource='',
            query='label_values(instance)',
            regex='nebula-node.*',
            allValues='nebula-node.*',
            current='all',
            refresh='load',
            includeAll=true,
            multi=true,
        ),

    k8s_namespace_template: template.new(
            name='namespace',
            datasource='',
            query='label_values(namespace)',
            allValues='.*',
            current='all',
            refresh='load',
            includeAll=true,
            multi=true,
        ),

    k8s_pod_template: template.new(
            name='pod',
            datasource='',
            query='label_values(pod)',
            regex='^(.*)-\\w+-\\w+$',
            allValues='.*',
            current='all',
            refresh='load',
            includeAll=true,
            multi=true,
        ),
}