# fastfood-authorizer-api

## Subir terraform Lambda

Esse projeto cria os recursos do AWS Lambda e AWS Gateway.

Para subir basta rodar os comandos: `terraform init` e `terraform apply` e ter os recursos de infra, rds e k8s criados.

## Ajustar Lambda

Caso precise ajustar o lambda, efetue as correções necessárias no index.js.

Rode o comando no diretório `./terraform/lambda/lambda_package` para instalar as dependências do node_modules: `npm install axios pg aws-sdk`.

Agora, no diretório `./terraform/lambda`, execute: `Compress-Archive -Path .\lambda_package\* -DestinationPath .\lambda_function.zip`.

Após isso, rode os comandos do `terraform init` e `terraform apply`.
