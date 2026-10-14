<!--
  02-install-sh-security.md -- Reference for oss-standards.

  Covers: payload verification, signature schemes, TLS hardening, and the
  piped-installer trust model. Read when securing an installer script.
-->

# install.sh security

## Algorithm

INPUT: the installer script plus the release assets it downloads.

1. **Verify the PAYLOAD, not just the transport.** HTTPS proves who you talked to; a checksum proves what you downloaded.
2. **Integrity (mandatory).** The installer MUST download `SHA256SUMS` published next to the tarball and verify before extracting. IF verification fails OR the checksum file is missing THEN exit nonzero (fail-closed). This is the single highest-value security line.
3. **Authenticity.** IF the project has users THEN add signatures: minisign (`SHASUMS256.txt.minisig`, shipped by mise) or GPG (`.asc`); keyless via Sigstore/cosign (see `10-supply-chain-security.md`). Integrity without authenticity is the professional floor; signatures are the SOON item.
4. **TLS hardening.** EVERY curl call MUST use `curl --proto '=https' --tlsv1.2 -fsSL` (rustup, mise pattern).
5. **Partial-download guard.** Wrap the whole script in `{ }` (nvm pattern) so a truncated pipe never executes half a script.
6. **Frame the trust ask honestly.** Document the "Manual Inspection" alternative (download, read, run -- oh-my-zsh pattern). State exactly what is verified and where the key lives (mise pattern).
7. **Privilege.** NEVER `curl | sudo bash`. Install to user-writable locations (`$PREFIX`, `~/.local/bin`) instead of demanding root.

## Verification matrix

| Level | Mechanism | Protects against |
|---|---|---|
| Transport | `--proto '=https' --tlsv1.2` | MITM, downgrade |
| Integrity | SHA256SUMS verified fail-closed | Corrupt/compromised mirror |
| Authenticity | minisign / GPG / Sigstore | Compromised release pipeline |

## FLAG on sight (FAIL)

- No checksum anywhere; "the CDN is trustworthy" as a security argument.
- Piping an installer into a root shell, or any sudo requirement for a user-space tool.
- Checksum fetched over the same channel with no signature and no honest disclosure (better than nothing, but say so).
