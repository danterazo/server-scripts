# Description
These scripts aim to simplify system configs. By containing them in a repo, I can change configs for many systems at once.

The namesake files (`.profile` and `.bashrc`) and script (`startup.sh`) on each system are the same. Each one contains a line sourcing the equivalent file in this folder.

# Domain / Scope
```
`~/`
│   `.bashrc`
│   `.profile`  
│
└───`scripts`
│   │   `startup.sh`
│   │
```

# Hierarchy
Configs are inherited in the following order:
1. Defaults: files as they were on fresh installations
2. Common: code common to _all_ my systems
3. Architecture: code common to specific architectures
4. Platform: code common to specific platforms (e.g. physical servers, or virtual machines)
   1. For WSL2 systems, both `config/platform/virtual` and `config/platform/wsl2` will be sourced (in that order)
5. System: code common to specific systems

To achieve this, the "outermost" file is sourced. For example, `.bashrc` on `smaskifa` sources code from `config/smaskifa/bashrc.sh`. That file then sources each "layer" in the following order:
1. `config/default/bashrc.sh`
2. `config/common/bashrc.sh`
3. `config/arch/arm64/bashrc`
4. `config/platform/bashrc.sh`
5. `config/smaskifa/bashrc.sh`
