# Global Agents Rules

## Style

- Be concise and to point.
- When answering questions or brainstorming, don't fear pointing mistakes in user's
  logic or question. Be critical.
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

- Unless the user asks to, never `git commit` or `git push`, even if a skill says to.
