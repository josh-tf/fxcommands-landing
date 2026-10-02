# fxcommands-landing

The landing and docs site for the FXCommands Stream Deck plugin, served at [josh.tf/fxcommands](https://josh.tf/fxcommands).

A small static Astro site with four pages: the home page, a setup guide, troubleshooting, and a profile migrator that updates exported Stream Deck profiles from the old plugin UUID to the current one. The migrator runs entirely in the browser, loading JSZip from jsDelivr to rewrite the profile file. The site is built with the `/fxcommands/` base path and published as static files inside the [josh.tf website](https://github.com/josh-tf/website) repo rather than deployed on its own.

## Stack

- Astro (static output), base path `/fxcommands/`
- sharp for image processing at build time
- GitHub Actions CI: builds on every push and pull request to `main` and checks the base path made it into the output

## Develop

Requires Node 22.12 or later and pnpm.

```sh
pnpm install
pnpm dev       # local dev server
pnpm build     # static output in dist/
```

## Deploy

`pnpm run deploy` runs `scripts/deploy.sh`, which builds the site, replaces `public/fxcommands/` in a local checkout of the website repo with `dist/`, commits that directory only, and pushes. The checkout defaults to `~/development/josh-tf/website`; set `WEBSITE_DIR` to override it. The website repo then needs its own deploy to go live. No secrets are needed beyond push access to the website repo.

## License

The code is [MIT](LICENSE). The written content and images are not covered by that licence and may not be reused without permission.
