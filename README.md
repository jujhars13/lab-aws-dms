# Lab AWS DMS

A lab working with [AWS DMS (Data Migration Service)](https://aws.amazon.com/dms/?nc=sn&loc=1)

## Objectives

To be able to simulate test and experience an AWS DMS migration of data from one database in a network to another database in a disparate network.

This is to demonstrate and experience a DB migration from an on-prem databases into the cloud.

## Architecture

```text
      Source VPC ("on-prem")                                                                      Destination VPC
┌───────────────────────────────────────────────────────┐                     ┌──────────────────────────────────────────────────────────────┐
│                                                       │                     │                                                              │
│   ┌─────────────────────────────────────────────┐     │                     │     ┌────────────────────────────────────────────────────┐   │
│   │    public/private subnet                    │     │                     │     │   public subnet                                    │   │
│   │                                             │     │                     │     │                                                    │   │
│   │     ┌─────────┐                             │     │                     │     │   ┌───────────┐                                    │   │
│   │     │         │Bastion                      │     │                     │     │   │           │ Bastion + DMS replication instance │   │
│   │     │         ├─────────────────────────────┼─────┼─────────────────────┼─────┼─► │           │                                    │   │
│   │     │         │                             │     │                     │     │   │           │                                    │   │
│   │     └─────────┘                             │     │                     │     │   └───────────┤                                    │   │
│   │          ▲                                  │     │                     │     │               └──────┐                             │   │
│   └──────────┬──────────────────────────────────┘     │                     │     └──────────────────────┼─────────────────────────────┘   │
│              │                                        │                     │                            │                                 │
│              │                                        │                     │                            │                                 │
│              │                                        │                     │                            │                                 │
│              │                                        │                     │                            │                                 │
│   ┌──────────┼───────────────────────────────────┐    │                     │     ┌──────────────────────┼─────────────────────────────┐   │
│   │     pvt db subnet                            │    │                     │     │     pvt db subnet    │                             │   │
│   │          │                                   │    │                     │     │                      ▼                             │   │
│   │      ┌───┴──────────┐                        │    │                     │     │         ┌──────────────┐                           │   │
│   │      │              │ EC2 w/ MySQL (Docker)  │    │                     │     │         │              │ RDS MySQL                 │   │
│   │      │              │                        │    │                     │     │         │              │                           │   │
│   │      │              │                        │    │                     │     │         │              │                           │   │
│   │      └──────────────┘                        │    │                     │     │         │              │                           │   │
│   │                                              │    │                     │     │         └──────────────┘                           │   │
│   └──────────────────────────────────────────────┘    │                     │     └────────────────────────────────────────────────────┘   │
│                                                       │                     │                                                              │
└───────────────────────────────────────────────────────┘                     └──────────────────────────────────────────────────────────────┘
```

## Requirements

- AWS
- Terraform > `v1.5`

## Proj structure

```bash
.
└── terraform
    ├── destination-db
    └── source-db
        ├── 01-state-store
        └── 02-base-infra
```

## Getting started

```bash
cd terraform\02-base-infra\source-db

terraform init
terraform plan
terraform apply

# to destroy
terraform destroy

```

To test bash scripts in a Vagrant VM:

```bash
# AWS Linux
vagrant destroy -f && vagrant up


```

### Improvements

- [ ] Make source network use a private network and reverse shell/tunnel into destination network - this would be considered more secure. In real life we'll probably use a VPC peer or a AWS Site-to-Site tunnel.
- [ ] Do a schema conversion while in flight using AWS DMS Schema conversion
  - [ ] Tweak the schema, keep the DBMS the same
  - [ ] Have the source db and target db be different DBMSs
- [ ] Experiment with fleet advisor and several databases
- [ ] Try DMS serverless
- [ ] Use Aurora as a target

## Todo

- [x] create arch diagram
- [ ] create source VPC
- [ ] create destination VPC
- [ ] create source RDS and dest RDS
- [ ] populate source RDS with some data
- [ ] ClickOps a database migration
