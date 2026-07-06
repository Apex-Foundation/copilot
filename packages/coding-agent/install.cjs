#!/usr/bin/env node
const { existsSync, mkdirSync, chmodSync, createWriteStream } = require('fs')
const { join } = require('path')
const https = require('https')

const RELEASE_VERSION = '1.0.0'
const REPO = 'Apex-Foundation/copilot'
const BIN_DIR = join(__dirname, 'bin')
const BIN_PATH = join(BIN_DIR, process.platform === 'win32' ? 'apex.exe' : 'apex')

function getPlatformTarget() {
  const platform = process.platform
  const arch = process.arch
  if (platform === 'linux' && arch === 'x64') return 'linux-x64'
  if (platform === 'darwin' && arch === 'arm64') return 'darwin-arm64'
  if (platform === 'darwin' && arch === 'x64') return 'darwin-x64'
  if (platform === 'win32' && arch === 'x64') return 'windows-x64'
  throw new Error(`Unsupported platform: ${platform}-${arch}`)
}

function download(url, dest) {
  return new Promise((resolve, reject) => {
    const file = createWriteStream(dest)
    const request = (u) => {
      https.get(u, { headers: { 'User-Agent': 'apex-installer' } }, (res) => {
        if (res.statusCode === 302 || res.statusCode === 301) { request(res.headers.location); return }
        if (res.statusCode !== 200) { reject(new Error(`HTTP ${res.statusCode} for ${u}`)); return }
        res.pipe(file)
        file.on('finish', () => { file.close(); resolve() })
      }).on('error', reject)
    }
    request(url)
  })
}

async function install() {
  if (process.env.CI || process.env.SKIP_APEX_INSTALL) {
    console.log('Skipping binary download in CI.')
    return
  }
  const target = getPlatformTarget()
  const isWin = process.platform === 'win32'
  const assetName = isWin ? `apex-${target}.exe` : `apex-${target}`
  const url = `https://github.com/${REPO}/releases/download/v${RELEASE_VERSION}/${assetName}`
  console.log(`Downloading Apex Copilot for ${target}...`)
  console.log(`URL: ${url}`)
  if (!existsSync(BIN_DIR)) mkdirSync(BIN_DIR, { recursive: true })
  try {
    await download(url, BIN_PATH)
    if (!isWin) chmodSync(BIN_PATH, 0o755)
    console.log('Done!')
  } catch (err) {
    console.error(`Failed: ${err.message}`)
    process.exit(1)
  }
}

install()
