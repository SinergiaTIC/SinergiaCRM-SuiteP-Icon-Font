# SuitepIcon Font

Builds an icon font for SuiteCRM/SinergiaCRM themes from SVG sources.

## Requirements

- **Node.js** — runtime for the font tooling
- **npm** — dependency manager
- **nvm** (optional but recommended) — Node version manager; reads `.nvmrc`
- **Docker** — to copy fonts into the SinergiaCRM container and recompile SCSS

## Full deployment (SinergiaCRM with Docker)

Run the end-to-end script:

```bash
bash SticInstallIcons.sh
```

The script does the following:

1. Deletes any leftover `tmpSrc/`
2. `git pull`s the latest icons
3. Copies `src/` → `tmpSrc/`
4. Auto-selects the Node version from `.nvmrc` (`nvm use`)
5. Installs dependencies with `npm ci`
6. Optimises Stic SVGs into `tmpSrc/` (`npm run icons:clean`)
7. Generates the font (`npm run font:build`)
8. Copies `suitepicon/` into the running Docker container
9. Recompiles every theme's SCSS → CSS inside the container (Stic, SticCustom, Dawn, Dusk, Day, Night, Noon)
10. Regenerates the icon preview HTML
11. Cleans up `tmpSrc/`

## Adding or modifying an icon

### 1. Prepare the SVG

- Start from an existing icon in `src/` or `SticSrc/` (easiest), or create a new one.
- Open it in **Inkscape** (or your vector editor of choice).
- Remove masks, clipping paths, and any `<image>` references.
- Resize the canvas to **1024×1024** pixels.
- Save as **Plain SVG** (not Inkscape SVG).

### 2. Place the file

- **SuiteP base icons** → put the `.svg` in `src/`
- **SinergiaCRM‑specific icons** → put the `.svg` in `SticSrc/`
  - The file name becomes the CSS class, e.g. `SticSrc/module-stic-signers.svg` → class `.suitepicon-module-stic-signers`

### 3. Rebuild

Run the full deployment script:

```bash
bash SticInstallIcons.sh
```

### Important notes

- Keep icons monochromatic and in a single path.
- If the SVG uses `transform` attributes, make sure transform functions (`translate`, `scale`, etc.) are **separated by whitespace**:

  ```svg
  transform="translate(0,512) scale(0.1,-0.1)"
  ```

  The build tool cannot parse `translate(0,512)scale(0.1,-0.1)` (no space). The SVGO config in `svgo.config.mjs` prevents the optimiser from stripping these spaces.

- If an icon doesn't render in the font, open `suitepicons.html` in a browser to check — it lists every glyph.
