NAMESPACE  ?= runners
CONTEXT    ?= k3s-pi
RELEASE    ?= pi-runner

# Deploy or upgrade the runner.
# Usage: make install GITHUB_PAT=ghp_xxxx
install:
	@test -n "$(GITHUB_PAT)" || (echo "ERROR: GITHUB_PAT is not set"; exit 1)
	helm upgrade --install $(RELEASE) . \
		-f values.yaml -f values-pi.yaml \
		--namespace $(NAMESPACE) --create-namespace \
		--kube-context $(CONTEXT) \
		--set github.token=$(GITHUB_PAT)

uninstall:
	helm uninstall $(RELEASE) --namespace $(NAMESPACE) --kube-context $(CONTEXT)

status:
	kubectl get pods -n $(NAMESPACE) --context $(CONTEXT) -l app.kubernetes.io/name=pi-runner

logs:
	kubectl logs -n $(NAMESPACE) --context $(CONTEXT) \
		-l app.kubernetes.io/name=pi-runner --tail=100 -f

.PHONY: install uninstall status logs
