[![Docker](https://github.com/WangLab-ComputationalBiology/btc-sc-containers/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/WangLab-ComputationalBiology/btc-sc-containers/actions/workflows/docker-publish.yml)

# BT-SC-CONTAINERS

```
docker buildx build -t oandrefonseca/scagnostic:1.0 -f $PWD/scAgnostic.Dockerfile .
docker buildx build -t oandrefonseca/scvariant:1.0 -f $PWD/scVariant.Dockerfile .
```

```
docker login ghcr.io --username <your_user_name> --password <generated_token_not_password>
docker pull ghcr.io/wanglab-computationalbiology/scbase:main
```

