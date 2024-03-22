# Cardano Node Configuration Guide

This document explains the bare minimum configuration needed to run a Cardano block producer (node) or a Cardano relay.

## Relay Configuration

### Default settings

- /opt/cardano/cnode/scripts/cnode.sh
Number of CPU cores cardano-node process has access to (please don't set higher than physical core count, recommended to set atleast to 4):
`CPU_CORES=4`

- /opt/cardano/cnode/scripts/env
Set relay port:
`CNODE_PORT=6000`


## Node Configuration (Block Producer)

### Default settings

- /opt/cardano/cnode/scripts/cnode.sh
Number of CPU cores cardano-node process has access to (please don't set higher than physical core count, recommended to set atleast to 4):
`CPU_CORES=4`

- /opt/cardano/cnode/scripts/env
Set relay port:
`CNODE_PORT=6000`
Set the pool's name to run node as a core node (the name, NOT the ticker, ie folder name):
`POOL_NAME="FOLDER_POOL_NAME"`

**Note:** Use `cntools` command to wallets and register a pool in any of the Cardano environments.

- terminal:~$ `cntools`

  [w] Wallet
  [f] Funds
  [p] Pool
  [t] Transaction
  [z] Backup & Restore
  [r] Refresh
  [q] Quit