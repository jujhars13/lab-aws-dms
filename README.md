# Lab AWS DMS

A lab to work with AWS DMS (Data Migration Service)

## Objective

To be able to simulate test and experience an AWS DMS migration of data from one database in a network to another database in a disparate network.

This is to demonstrate and experience a DB migration from an on-prem databases into the cloud.

## Architecture

```text
      Source VPC                                                                       Destination VPC
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
│   │          ▲                                  │     │                     │     │               ┼──────┐                             │   │
│   └──────────┬──────────────────────────────────┘     │                     │     └──────────────────────┼─────────────────────────────┘   │
│              │                                        │                     │                            │                                 │
│              │                                        │                     │                            │                                 │
│              │                                        │                     │                            │                                 │
│              │                                        │                     │                            │                                 │
│   ┌──────────┼───────────────────────────────────┐    │                     │     ┌──────────────────────┼─────────────────────────────┐   │
│   │     pvt d│ subnet                            │    │                     │     │     pvt db subnet    │                             │   │
│   │          │                                   │    │                     │     │                      ▼                             │   │
│   │      ┌───┴──────────┐                        │    │                     │     │         ┌──────────────┐                           │   │
│   │      │              │ EC2 w/ MySQL (docker)  │    │                     │     │         │              │ Aurora MySQL              │   │
│   │      │              │                        │    │                     │     │         │              │                           │   │
│   │      │              │                        │    │                     │     │         │              │                           │   │
│   │      └──────────────┘                        │    │                     │     │         │              │                           │   │
│   │                                              │    │                     │     │         └──────────────┘                           │   │
│   └──────────────────────────────────────────────┘    │                     │     └────────────────────────────────────────────────────┘   │
│                                                       │                     │                                                              │
└───────────────────────────────────────────────────────┘                     └──────────────────────────────────────────────────────────────┘
```

### Improvements

- [ ] make source network use a private network and reverse shell/tunnel into destination network - this would be considered more secure. In real life we'll probably use a VPC peer or a AWS Site-to-Site tunnel.
- [ ] Do a schema conversion while in flight using AWS DMS Schema conversion
  - [ ] Tweak the schema
  - [ ] Have the source db and target db be different DBMSs
- [ ] Experiment with fleet advisor and several databases
- [ ] Try DMS serverless
- [ ] Use Aurora as a target

## Todo

- [ ] create arch diagram
- [ ] create source VPC
- [ ] create destination VPC
- [ ] create source RDS and dest RDS
- [ ] populate source RDS with some data
- [ ] ClickOps a database migration
