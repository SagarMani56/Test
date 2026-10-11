.PHONY: test validate new-service localstack
test:
	cd app && pip install -r requirements-dev.txt && pytest --cov=src
validate:
	scripts/validate-local.sh
new-service:
	scripts/new-service.sh $(NAME) $(TEAM)
localstack:
	scripts/localstack-demo.sh $(or $(EX),ims)
