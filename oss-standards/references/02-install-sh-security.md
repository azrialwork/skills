<!--
  02-install-sh-security.md -- Reference for oss-standards.

  Covers: payload verification, signature schemes, TLS hardening, and the
  curl|bash trust model. Read when securing an installer script.
-->

# install.sh security

## The standard

1. **Verify the PAYLOAD, not just the transport.** HTTPS only proves who
   you talked to; a checksum proves what you downloaded.
   - **SHA256SUMS (fail-closed):** the single highest-value security line.
     Publish `SHA256SUMS` next to the tarball; the installer downloads it
     and verifies before extracting. mise embeds the SHA256 for the pinned
     release and fetches `SHASUMS256.txt` for others; uv runs
     `verify_checksum` when the checksum is known and honestly reports
     "no checksums to verify" when it is not.
   - **Signatures (authenticity):** minisign (`SHASUMS256.txt.minisig`,
     shipped by mise) or GPG (`.asc`). Keyless: Sigstore/cosign
     (see `10-supply-chain-security.md`).
2. **TLS hardening on every curl call:**
   `curl --proto '=https' --tlsv1.2 -fsSL` (rustup, mise pattern).
3. **Partial-download guard:** nvm wraps the whole script in `{ }` so a
   truncated pipe never executes half a script.
4. **Frame the trust ask honestly.** oh-my-zsh documents "Manual
   Inspection": download the script, read it, then run it. mise's docs
   state exactly what is verified (SHA256SUMS + key location).
5. **Never `curl | sudo bash`.** Install to user-writable locations
   (`$PREFIX`, `~/.local/bin`) instead of demanding root.

## Verification matrix

| Level | Mechanism | Protects against |
|---|---|---|
| Transport | `--proto '=https' --tlsv1.2` | MITM, downgrade |
| Integrity | SHA256SUMS verified fail-closed | Corrupt/compromised mirror |
| Authenticity | minisign / GPG / Sigstore | Compromised release pipeline |

Integrity without authenticity is the common professional floor; add
signatures as soon as the project has users (roadmap SOON item).

## Anti-patterns

- No checksum anywhere; "the CDN is trustworthy" as a security argument.
- `curl | sudo bash` or any sudo requirement for a user-space tool.
- Verifying with a checksum fetched over the same channel with no
  signature (better than nothing, but say so honestly).
