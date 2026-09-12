# Code Search

Applies only for git project directories:
<!-- vera:begin -->
Use Vera before opening many files or running broad text search when you need to find where logic lives or how a feature works.
- `vera search "query"` for semantic code search. Describe behavior: "JWT validation", not "auth". If one phrasing misses, try 2-3 varied queries or add `--intent "goal"`.
- `vera search ... --changed`, `--since <rev>`, or `--base <rev>` when the task is limited to modified files or a PR diff
- `vera grep "pattern"` for exact text or regex in indexed files
- `vera structural definitions <symbol>`, `vera structural env <NAME>`, `vera structural routes`, or `vera structural impls <symbol>` for common structural tasks and explicit type relationships
- `vera explain-path path/to/file` to explain why a file is or is not indexed
- `vera references <symbol>` for callers and `vera references <symbol> --callees` for callees
- `vera overview` for a project summary (languages, entry points, hotspots). Add `--changed`, `--since <rev>`, or `--base <rev>` to scope it to modified files.
- `vera stats --json` for index health, including tree-sitter error, parse-failure, and Tier 0 fallback counts
- `vera search --deep "query"` for RAG-fusion query expansion + merged ranking
- Narrow `vera search` or `vera grep` with `--lang`, `--path`, `--type`, or `--scope docs`
- `vera watch .` to auto-update the index, or `vera update .` after edits (`vera index .` if `.vera/` is missing)
- For detailed usage, query patterns, and troubleshooting, read the Vera skill file installed by `vera agent install`
<!-- vera:end -->

# Browser preference

- Prefer `terminal-browser` for user-visible browsing, UI inspection, or interactive web work when it can render in a separate terminal surface. Under Herdr, use `omp-terminal-browser-open <url>`; it verifies pane graphics, chooses a usable split, launches the browser without stealing focus, matches it to the created pane, and returns JSON containing `pane_id`, `browser_key`, and `cdp_port`. Target every subsequent command with `terminal-browser action --browser <browser_key> -- ...`. If the launcher fails, use OMP's built-in browser rather than reconstructing or bypassing its safety checks. Linux Ghostty does not support terminal-browser's own `--split`; outside Herdr, reuse a known browser with `terminal-browser new-tab <url> --browser <key>` or fall back to OMP's built-in browser rather than replacing the OMP pane.
- Use direct URL reads for static content. Use OMP's built-in browser device when terminal-browser is unavailable, cannot render visibly in the current host, or the task specifically requires Puppeteer.
