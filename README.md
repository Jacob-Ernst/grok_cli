# GrokCLI

Here's your one-stop shop for common docker command management.

## Installation

```bash
gem install grok_cli
```

## Usage

```bash

# List universal commands
grok help docker

# List Rails-specific commands
grok help docker:rails

# List Node-specific commands
grok help docker:node
```

## Quickstart: Rails

```
# List universal commands
grok docker:rails setup
grok docker:rails test [$OPTIONS]

grok docker start
```

## Quickstart: Node

```
# List universal commands
grok docker:node setup
grok docker:node test [$OPTIONS]

grok docker start
```


## Everything Else

```bash
grok docker run $COMMAND
```
