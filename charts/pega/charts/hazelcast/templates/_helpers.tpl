{{- define "hazelcastDeploymentName" }}{{ $hazelcastDeploymentName := .defaultname }}{{ if (.root.deployment) }}{{ if (.root.deployment.name) }}{{ $hazelcastDeploymentName = .root.deployment.name }}{{ end }}{{ end }}{{ $hazelcastDeploymentName }}{{- end -}}

{{- define "hazelcastName" -}}{{ include "hazelcastDeploymentName" (dict "root" .Values "defaultname" "pega-hazelcast" )}}{{- end -}}
{{- define "hazelcastEnvironmentConfig" -}}{{include "hazelcastName" .}}-env-config {{- end -}}

{{- define "clusteringServiceName" -}}{{ include "hazelcastDeploymentName" (dict "root" .Values "defaultname" "clusteringservice" )}}{{- end -}}
{{- define "clusteringServiceEnvironmentConfig" -}}{{include "clusteringServiceName" .}}-env-config {{- end -}}

{{- define "isHazelcastEnabled" }}
 {{- if .Values.enabled -}}
  true
 {{- else -}}
  false
 {{- end -}}
{{- end }}

{{- define "isClusteringServiceEnabled" }}
 {{- if .Values.clusteringServiceEnabled -}}
  true
 {{- else -}}
  false
 {{- end -}}
{{- end }}

{{- define "isMigrationInit" }}
 {{- if .Values.migration.initiateMigration -}}
  true
 {{- else -}}
  false
 {{- end -}}
{{- end }}

{{- define "hazelcastVolumeCredentials" }}hazelcast-volume-credentials{{- end }}

{{- define "hazelcastVolumeTemplate" }}
- name: {{ template "hazelcastVolumeCredentials" }}
  projected:
    defaultMode: 420
    sources:
    {{- $d := dict "deploySecret" "deployHzServerSecret" "deployNonExtsecret" "deployNonExtHzServerSecret" "extSecretName" .Values.external_secret_name "nonExtSecretName" "pega-hz-secret-name" "context" $ -}}
    {{ include "secretResolver" $d | indent 4}}
{{- end}}

{{- define "deployHzServerSecret" -}}
true
{{- end }}

{{- define "deployNonExtHzServerSecret" }}
{{- if and (eq (include "deployHzServerSecret" .) "true") (not (.Values).external_secret_name) -}}
true
{{- else -}}
false
{{- end -}}
{{- end -}}

# Override this template to generate additional pod annotations that are dynamically composed during helm deployment (do not indent annotations)
{{- define "generatedHazelcastServicePodAnnotations" }}
{{- end }}

# Override this template to generate additional service annotations that are dynamically composed during helm deployment (do not indent annotations)
{{- define "generatedHazelcastServiceAnnotations" }}
{{- end }}

# Override this template to generate additional pod annotations that are dynamically composed during helm deployment (do not indent annotations)
{{- define "generatedClusteringServicePodAnnotations" }}
{{- end }}

# Override this template to generate additional pod labels that are dynamically composed during helm deployment (do not indent annotations)
{{- define "generatedHazelcastServicePodLabels" }}
{{- end }}

# Override this template to generate additional service annotations that are dynamically composed during helm deployment (do not indent annotations)
{{- define "generatedClusteringServiceAnnotations" }}
{{- end }}

# Override this template to generate additional pod labels that are dynamically composed during helm deployment (do not indent annotations)
{{- define "generatedClusteringServicePodLabels" }}
{{- end }}


{{- define "performDeployment" }}
  {{- if or (eq .Values.global.actions.execute "deploy") (eq .Values.global.actions.execute "install-deploy") (eq .Values.global.actions.execute "upgrade-deploy") -}}
    true
  {{- else -}}
    false
  {{- end -}}
{{- end }}