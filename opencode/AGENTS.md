# Global Agents Rules

## Style

- Be concise and to point.
- When answering questions or brainstorming, don't fear pointing mistakes in user's logic
  or question. Be critical.
- Use web searches and code searches to validate assumptions.
- When planning, drill user with questions to get complete picture of problem.

## Code

- Avoid one or two line comments and separation/section comments. But use docstrings and
  other documentation comments.
- Avoid big functions or too nested function. If adding to function already big, make new
  function with new stuff and call it from the old one.
- Prefer methods for dealing with shared state.
- Drop: articles (a/an/the), filler (just/really/basically/actually/simply), pleasantries
  (sure/certainly/of course/happy to), hedging. Fragments OK. Short synonyms (big not
  extensive, "fix" not "implement a solution for"). Technical terms exact. Code blocks
  unchanged. Errors quoted exact. Code/commits/PRs: write normal.

## Restrictions

- Unless the user asks to, never do destructive git operations, like `git reset`,
  `git checkout`, or `git rebase`, even if a skill says it's okay to do so.

## RTK (Rust Token Killer)

- rtk hooks the command tool to save tokens for common commands. Example: `git diff`
  becomes `rtk git diff`, saving 75% of tokens.
- rtk hooks are done automatically, so you don't need to add them to your commands.
- If a rtk command is giving you trouble, you can disable it with `RTK_DISABLED=1` env
  var. Example: `RTK_DISABLED=1 rtk git diff`.
- Quirks to note:
    - `rtk git diff` shows only the stats for big diffs.
    - `rtk ls` filters out some ignored files like `.git`, `node_modules`, etc.

## CodeGraph

In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root),
reach for it BEFORE grep/find or reading files when you need to understand or locate code:

- **MCP tool** (when available): `codegraph_explore` answers most code questions in one
  call — the relevant symbols' verbatim source plus the call paths between them, including
  dynamic-dispatch hops grep can't follow. Name a file or symbol in the query to read its
  current line-numbered source. If it's listed but deferred, load it by name via tool
  search.
- **Shell** (always works): `codegraph explore "<symbol names or question>"` prints the
  same output.

If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's
decision.
