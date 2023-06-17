### Host baza seed node

This guide is written assuming you are setting up in a linux distribution

You will need to setup minimum two seed node

-   Download the latest binary from here [https://github.com/Baza-Foundation/baza-coin/releases](https://github.com/Baza-Foundation/baza-coin/releases)
-   Copy bazad to `/usr/bin`
-   Copy bazad.service to `/lib/systemd/system/bazad.service` and edit as per your choices
-   Reload systemd manager configuration

```bash
sudo systemctl daemon-reload
```

-   Run bazad

```bash
sudo systemctl start bazad.service
```

-   Enable it to run at boot

```bash
sudo systemctl enable bazad.service
```

-   Let it complete syncing the chain

### Add new nodes IP to baza source

-   Fork [https://github.com/Baza-Foundation/baza-coin](https://github.com/Baza-Foundation/baza-coin)
-   Add new seed nodes IP here [https://github.com/Baza-Foundation/baza-coin/blob/main/src/config/CryptoNoteConfig.h#L271](https://github.com/Baza-Foundation/baza-coin/blob/main/src/config/CryptoNoteConfig.h#L271)
-   Recompile for all platform and release
-   Replace the seed node binary with the new binary
