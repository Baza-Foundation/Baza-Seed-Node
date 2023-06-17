### Host baza seed node

Follow these steps to run baza in docker

-   Clone this repo

```bash
git clone https://github.com/Baza-Foundation/Baza-Seed-Node.git
```

-   Build the image

```bash
docker-compose build
```

-   Start the node

```bash
docker-compose up -d
```

### Add new nodes IP to baza source

-   Fork [https://github.com/Baza-Foundation/baza-coin](https://github.com/Baza-Foundation/baza-coin)
-   Add new seed nodes IP here [https://github.com/Baza-Foundation/baza-coin/blob/main/src/config/CryptoNoteConfig.h#L271](https://github.com/Baza-Foundation/baza-coin/blob/main/src/config/CryptoNoteConfig.h#L271)
-   Recompile for all platform and release
-   Edit the Dockerfile ar line 43 and 44 to include new binary
-   Restart the bazad container
