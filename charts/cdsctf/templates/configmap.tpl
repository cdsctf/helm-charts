apiVersion: v1
kind: ConfigMap
metadata:
  name: server-config
  namespace: {{ include "cdsctf.namespace" . }}
  labels:
    {{- include "cdsctf.labels" . | nindent 4 }}
data:
  config.toml: |
    [server]
    host = "0.0.0.0"
    port = 8888
    frontend = "./dist"
    burst_restore_rate = {{ .Values.server.config.server.burstRestoreRate | default 1000 }}
    burst_limit = {{ .Values.server.config.server.burstLimit | default 2048 }}

    [db]
    host = {{ .Values.server.config.db.host | quote }}
    port = {{ .Values.server.config.db.port | default 5432 }}
    dbname = {{ .Values.server.config.db.dbname | quote }}
    username = {{ .Values.server.config.db.username | quote }}
    password = {{ .Values.server.config.db.password | quote }}
    ssl_mode = {{ .Values.server.config.db.sslMode | default "disable" | quote }}

    [queue]
    host = {{ .Values.server.config.queue.host | quote }}
    port = {{ .Values.server.config.queue.port | default 4222 }}
    username = {{ .Values.server.config.queue.username | quote }}
    password = {{ .Values.server.config.queue.password | quote }}
    token = {{ .Values.server.config.queue.token | quote }}
    tls = {{ .Values.server.config.queue.tls | default false }}

    [media]
    path = "./data/media"

    [logger]
    level = "info,sqlx=debug,sea_orm=debug,cds_web=debug"

    [cache]
    url = {{ .Values.server.config.cache.url | quote }}

    [cluster]
    namespace = {{ .Values.server.config.cluster.namespace | quote }}
    auto_infer = true
    config_path = ""
    traffic = {{ .Values.server.config.cluster.traffic | quote }}
    public_entry = {{ .Values.server.config.cluster.publicEntry | quote }}

    [observe]
    is_enabled = {{ .Values.server.config.observe.enabled | default false }}
    protocol = "grpc"  # grpc | json | binary
    endpoint_url = {{ .Values.server.config.observe.endpointURL | quote }}
---

{{- if .Values.otel.enabled }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: otel-config
  namespace: {{ include "cdsctf.namespace" . }}
  labels:
    {{- include "cdsctf.labels" . | nindent 4 }}
data:
  config.yaml: |
    {{ .Values.otel.config | nindent 4 }}
---
{{- end }}