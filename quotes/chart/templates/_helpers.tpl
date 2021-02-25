{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "hostname" -}}
{{- printf "%s.%s.%s" .Values.application_name .Release.Namespace .Values.ingress.domain -}}
{{- end -}}
