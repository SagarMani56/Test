.PHONY: test validate new-service localstack
test:
	cd app && pip install -r requirements-dev.txt && pytest --cov=src
validate:
	bash scripts/validate-local.sh
new-service:
	bash scripts/new-service.sh $(NAME) $(TEAM)
localstack:
	bash scripts/localstack-demo.sh $(or $(EX),ims)
