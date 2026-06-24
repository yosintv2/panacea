import { writeFileSync, rmSync, mkdirSync, existsSync, renameSync, readdirSync } from 'fs'
import { join, dirname } from 'path'
import { fileURLToPath } from 'url'

const dist = join(dirname(fileURLToPath(import.meta.url)), '..', 'dist')
const server = join(dist, 'server')

// Move client assets to dist/ root for Pages static serving
const client = join(dist, 'client')
if (existsSync(client)) {
  for (const entry of readdirSync(client)) {
    const src = join(client, entry)
    const dest = join(dist, entry)
    if (existsSync(dest)) rmSync(dest, { recursive: true })
    renameSync(src, dest)
  }
  rmSync(client, { recursive: true })
}

// Remove generated wrangler.json to avoid Pages validation conflicts
const wranglerJson = join(server, 'wrangler.json')
if (existsSync(wranglerJson)) rmSync(wranglerJson)

// Remove cached deploy config
const cachedConfig = join(dirname(dist), '.wrangler', 'deploy', 'config.json')
if (existsSync(cachedConfig)) rmSync(cachedConfig)

// Create _worker.js at dist root for Cloudflare Pages
// It wraps the server entry and serves static assets via env.ASSETS
const serverEntry = join(server, 'entry.mjs')
if (existsSync(serverEntry)) {
  const ts = Date.now()
  const workerContent = `// build:${ts}
import entry from "./server/entry.mjs";

export default {
  async fetch(request, env, ctx) {
    if (request.method === "GET" || request.method === "HEAD") {
      const asset = await env.ASSETS.fetch(request);
      if (asset.status !== 404) return asset;
    }
    return entry.fetch(request, env, ctx);
  }
};
`
  writeFileSync(join(dist, '_worker.js'), workerContent)
}
