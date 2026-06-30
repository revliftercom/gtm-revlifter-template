# RevLifter — Google Tag Manager Template

A Google Tag Manager custom tag template for deploying RevLifter on your website.
Add the tag, enter your RevLifter Site UUID, and the template initialises the
RevLifter loader and fires the `load` command — no Custom HTML or manual code
editing required.

## What it does

This template reproduces the standard RevLifter on-page snippet using GTM's
sandboxed JavaScript APIs. When the tag fires it:

1. Sets `window.RevLifterObject = 'revlifter'`.
2. Creates the `window.revlifter` command queue.
3. Fires `revlifter('load', '<SITE_UUID>')`.
4. Asynchronously injects `https://assets.revlifter.io/<SITE_UUID>.js`.

The loader manages its own timing internally, so no timestamp property needs to be
set on the page.

## Installation

### From the Community Template Gallery

1. In your GTM container, go to **Templates → Tag Templates → Search Gallery**.
2. Search for **RevLifter** and add it to your workspace.
3. Create a new tag and select the **RevLifter** template.
4. Enter your **RevLifter Site UUID** (You should have already received your [SITE_UUID] variables from us).
5. Add a trigger — typically **All Pages** (Page View).
6. Save, preview to confirm the tag fires and the loader request to
   `assets.revlifter.io` succeeds, then publish.

### Manual import

1. Download `template.tpl` from this repository.
2. In GTM: **Templates → New → ⋮ menu → Import**, then select `template.tpl`.
3. Follow steps 3–6 above.

## Configuration

| Field | Required | Description |
| --- | --- | --- |
| **RevLifter Site UUID** | Yes | Your unique RevLifter Site UUID. Used to build the loader URL and fire the `load` command. |

## Permissions

The template requests only the permissions it uses:

- **Inject Scripts** — limited to `https://assets.revlifter.io/*`.
- **Access Globals** — `revlifter` (read, write, execute) and `RevLifterObject`
  (write).

## Privacy & consent

This tag loads a third-party script from `assets.revlifter.io`. If you operate
under GDPR or a similar regime and RevLifter is non-essential, gate the tag behind
your consent management platform or GTM Consent Mode so it only fires after the
appropriate consent is granted.

## Support

For help with your RevLifter account, Site UUID, or the RevLifter platform, contact
RevLifter through your account manager or [revlifter.com](https://www.revlifter.com).

## License

Released under the [Apache License 2.0](LICENSE).
