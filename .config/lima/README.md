# Lima sandbox VM

A Lima VM (`sandbox`) for running Claude Code in `--dangerously-skip-permissions`
mode with a contained blast radius. Host `$HOME` is never mounted; projects are
exposed per-project, on demand, writable.

Config: [`sandbox.yaml`](./sandbox.yaml)

## Architecture

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  macOS host  (Apple Silicon · 128 GB RAM · 16 cores · Darwin 25.4)           │
│                                                                              │
│  Host filesystem                                Lima control plane           │
│  ─────────────────                              ──────────────────           │
│  ~/.ssh/                ⛔ not mounted          /opt/homebrew/bin/limactl    │
│  ~/.aws/                ⛔ not mounted          ~/.config/lima/sandbox.yaml  │
│  ~/.config/             ⛔ not mounted             (config: 6cpu/16G/200G)   │
│  ~/workspace/  219 GB   ⛔ not mounted whole    ~/.lima/sandbox/             │
│   ├─ trailofbits/                                  ├─ basedisk.img           │
│   ├─ trail-of-forks/    ┐                          ├─ diffdisk               │
│   ├─ akshithg/          │ per-project,             ├─ ha.sock                │
│   ├─ lifting-bits/      │ on-demand               └─ serial*.log             │
│   └─ ...                ┘ writable mount                                     │
│                            (edit yaml,            Apple Virtualization.fwk   │
│                             stop+start VM)                  ▲                │
│                                  │                          │ vmType: vz     │
│                                  │                          │                │
│  ════════════════════════════════╪══════════════════════════╪══════════ trust│
│                                  │   virtiofs               │           bound│
│                                  ▼   + inotify              ▼                │
│  ┌────────────────────────────────────────────────────────────────────────┐  │
│  │  sandbox VM  (Ubuntu 24.04 aarch64 · 6 vCPU · 16 GiB · 200 GiB)         │  │
│  │                                                                        │  │
│  │  /Users/akshithg/workspace/<project>/   ← mounted writable on demand   │  │
│  │      (empty by default — mounts: [] in yaml)                           │  │
│  │                                                                        │  │
│  │  System packages           User env (/home/akshithg.guest)             │  │
│  │  ────────────────          ─────────────────────────────               │  │
│  │  nodejs 22 (NodeSource)    ~/.npm-global/bin/                          │  │
│  │  git, build-essential        └─ claude  2.1.139                        │  │
│  │  ripgrep, fd, jq           ~/.profile  → PATH includes npm-global      │  │
│  │                                                                        │  │
│  │  ┌──────────────────────────────────────────────────────────────────┐  │  │
│  │  │  claude --dangerously-skip-permissions                           │  │  │
│  │  │  blast radius = this VM + currently-mounted project only         │  │  │
│  │  └──────────────────────────────────────────────────────────────────┘  │  │
│  │                                                                        │  │
│  │  SSH:  lima-generated key only  (loadDotSSHPubKeys: false)             │  │
│  └────────────────────────────────────────────────────────────────────────┘  │
│         ▲                                                                    │
│         │  limactl shell sandbox  /  ssh -p <auto-forwarded>                 │
└─────────┴────────────────────────────────────────────────────────────────────┘
```

### Reading the diagram

- **Trust boundary** is the double line. Above it runs on the host; below runs
  in the VM. The only things crossing it are (a) virtiofs mounts you opt into
  and (b) `limactl shell` / SSH.
- **Default state is closed.** `mounts: []` means no host paths reach the VM.
  Adding a project requires editing the yaml and bouncing the VM — explicit,
  reviewable, revertable.
- **Credentials don't cross.** Host `~/.ssh` isn't mounted, and
  `loadDotSSHPubKeys: false` blocks host pubkeys from being trusted inside.
  Claude Code's VM auth is independent of the host auth.
- **`vz`** = Apple Virtualization.framework (not QEMU). Native hypervisor,
  fast on Apple Silicon.
- **Blast radius of a bypassed agent** is the inner box: the VM disk plus
  whatever project is currently mounted. Not your host, not other projects,
  not your keys.

## Common operations

| Goal                              | Command                                             |
| --------------------------------- | --------------------------------------------------- |
| Open a shell in the VM            | `limactl shell sandbox`                             |
| Run Claude Code in bypass mode    | `limactl shell sandbox -- claude --dangerously-skip-permissions` |
| Stop / start the VM               | `limactl stop sandbox` · `limactl start sandbox`    |
| List VMs                          | `limactl list`                                      |
| Watch boot / provision logs       | `tail -f ~/.lima/sandbox/serial*.log`               |
| Re-run provisioning               | `limactl stop sandbox && limactl start sandbox`     |
| Delete the VM (keeps yaml)        | `limactl delete sandbox`                            |

## Mounting a project

Edit [`sandbox.yaml`](./sandbox.yaml), add under `mounts:`:

```yaml
mounts:
- location: "~/workspace/trailofbits/some-project"
  writable: true
```

Then bounce the VM:

```sh
limactl stop sandbox && limactl start sandbox
```

The path appears at the same location inside the VM
(`/Users/akshithg/workspace/trailofbits/some-project`). To unmount, remove the
entry and bounce again.

## First-run auth

Claude Code's host install and the VM install have separate credentials — by
design. Inside the VM, the first `claude` invocation will prompt for login.
That keeps the bypassed agent from inheriting your host session.
