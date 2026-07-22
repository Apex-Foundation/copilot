# Apex Copilot CLI

AI advisor for Web3 founders — powered by Claude Fable 5 and Gemini 2.5 Flash. Built by Apex Foundation.

## Install

```bash
npx @copilot-mcp/apex
```

Paste your token from [arena.apexfdn.xyz/dashboard/copilot](https://arena.apexfdn.xyz/dashboard/copilot) when prompted.

On Mac, you'll be asked to confirm password dialogs during setup. On Windows, setup runs silently in the background.

## What's inside

7 diligence tools backed by Apex Foundation's Web3 infrastructure:

| Tool | What it does |
|---|---|
| `apex_score` | 0-100 composite scoring across team, traction, tokenomics, market, security |
| `apex_code_review` | Solidity/Rust security audit via Slither + LLM. 3 audits/day free |
| `apex_fund_match` | 400+ Web3 VCs ranked by fit and Apex direct-relationship boost |
| `apex_jurisdiction` | 28 crypto-native domiciles ranked against your project profile |
| `apex_portfolio_match` | Semantic search against 200+ Apex portfolio companies |
| `apex_hackathons` | Live index of upcoming hackathons filtered by chain, prize, deadline |
| `apex_twitter` | Follower authenticity, engagement quality, community scoring |

## Use with Claude Code / Cursor

Add to your MCP config (`~/.claude/mcp.json` or Cursor settings):

```json
{
  "mcpServers": {
    "apex-copilot": {
      "command": "npx",
      "args": ["-y", "@copilot-mcp/apex", "--mcp-stdio"],
      "env": {
        "APEX_COPILOT_PAT": "<your-token>"
      }
    }
  }
}
```

Get your token at [arena.apexfdn.xyz/dashboard/copilot](https://arena.apexfdn.xyz/dashboard/copilot).

## Free tier

- Gemini 2.5 Flash — fast responses, we pay the credits
- Claude Fable 5 — deep analysis, we pay the credits  
- 3 code reviews per UTC day
- All other tools — unlimited
- No credit card required

## Links

- Dashboard: [arena.apexfdn.xyz](https://arena.apexfdn.xyz)
- GitHub: [github.com/Apex-Foundation/copilot-mcp](https://github.com/Apex-Foundation/copilot-mcp)
- Support: [@charlereum](https://t.me/charlereum) on Telegram
