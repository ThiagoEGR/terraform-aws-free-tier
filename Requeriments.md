Desafio Aula 07 — Infra AWS com Terraform
Missão: com um único terraform apply, suba numa só VPC tudo o que vimos da Aula 04 à 07 (rede + compute + storage), dentro do Free Tier. Região: us-east-1. Quando o terraform plan mostrar ~35 recursos (sem os bônus), está no caminho certo.

Pré-requisitos: conta AWS (Free Tier ou LocalStack), AWS CLI autenticado, Terraform ≥ 1.5.

Regras Free Tier (obrigatório): use t3.micro e db.t3.micro (single-AZ); NÃO suba NAT Gateway nem ASG/ALB (são bônus opcional). Rode terraform destroy ao final.

O que construir (nesta ordem):

1. Rede
- VPC 10.0.0.0/16 (DNS hostnames habilitado)
- 2 subnets públicas — 10.0.1.0/24 (us-east-1a) e 10.0.2.0/24 (us-east-1b), com IP público automático
- 2 subnets privadas — 10.0.11.0/24 (us-east-1a) e 10.0.12.0/24 (us-east-1b)
- IGW + route table pública (0.0.0.0/0 → IGW) associada às públicas
Route table privada associada às privadas, sem rota de saída (sem NAT)

2. Segurança
- SG web/app: entrada 80 e 443 de 0.0.0.0/0
- SG RDS: entrada 5432 só do SG web/app (nunca da internet)

3. Compute
- EC2 t3.micro em subnet pública, AMI Amazon Linux 2023 (via data source), IAM Role + AmazonSSMManagedInstanceCore + Instance Profile (acesso por SSM, sem SSH), user_data subindo o httpd
- Lambda Node.js 20 (index.handler) + role com AWSLambdaBasicExecutionRole; API Gateway HTTP (proxy) com rota POST /

4. Storage

- RDS PostgreSQL 15.4, db.t3.micro, single-AZ, 20 GB gp2, sem acesso público, backup 7 dias, DB subnet group nas privadas; senha via variável sensível (sem hardcode)
- S3: versionamento + Block Public Access total
- DynamoDB Pedidos (PAY_PER_REQUEST; PK clienteId, SK pedidoId; GSI status-index por status, projeção ALL)

Outputs esperados: id da VPC, ids das subnets, ids dos SGs, IP público da EC2, endpoint do RDS, nome do bucket, URL do API Gateway, nome da tabela.

Fluxo: fmt → init → validate → plan → apply (teste tudo) → destroy.

Bônus (⚠️ fora do Free Tier): NAT Gateway (dá saída às privadas) e ASG + ALB com target tracking de CPU a 60%. Exigem terraform destroy logo após a demo.

Evidências para entregar:
1. O código .tf (zip ou link do repositório).
2. Screenshot do apply/destroy.