# Cardano Node Configuration Guide

This document explains the bare minimum configuration needed to run a Cardano block producer (node) or a Cardano relay.

## Relay Configuration

### Default settings

- /opt/cardano/cnode/scripts/cnode.sh
```bash
# Number of CPU cores for the cardano-node process. Minimum of 4-cores recommended:
`CPU_CORES=4`
```
- /opt/cardano/cnode/scripts/env
```bash
# Set relay port:
`CNODE_PORT=6000`
```


## Node Configuration (Block Producer)

### Default settings

- /opt/cardano/cnode/scripts/cnode.sh
```bash
# Number of CPU cores for the cardano-node process. Minimum of 4-cores recommended:
`CPU_CORES=4`
```

- /opt/cardano/cnode/scripts/env
```bash
# Set relay port:
`CNODE_PORT=6000`
# Set the pool's name to run node as a core node (the name, NOT the ticker, ie folder name):
`POOL_NAME="FOLDER_POOL_NAME"`
```

**Note:** Use `cntools` command to wallets and register a pool in any of the Cardano environments.

- terminal:~$ `cntools`
```bash
  - [w] Wallet
  - [f] Funds
  - [p] Pool
  - [t] Transaction
  - [z] Backup & Restore
  - [r] Refresh
  - [q] Quit
```