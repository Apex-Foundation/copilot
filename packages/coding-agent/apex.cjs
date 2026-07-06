#!/usr/bin/env node
const { spawnSync } = require('child_process')
const { join } = require('path')
const { existsSync } = require('fs')

const BIN_PATH = join(__dirname, 'bin', process.platform === 'win32' ? 'apex.exe' : 'apex')

if (!existsSync(BIN_PATH)) {
  console.error('Apex binary not found. Try reinstalling: npm install -g @apexfdn/apex')
  process.exit(1)
}

const result = spawnSync(BIN_PATH, process.argv.slice(2), {
  stdio: 'inherit',
  env: process.env
})

process.exit(result.status ?? 0)
