# Hop

Hop è un'app nativa per macOS che raccoglie le macchine SSH in un'interfaccia essenziale. Selezionando una macchina si apre una sessione terminale nell'app. Ogni macchina può avere tunnel SSH configurati e può partecipare a trasferimenti di file via SFTP.

## Obiettivo del prodotto

- Elenco di macchine configurabili: nome, indirizzo, porta, utente e metodo di autenticazione.
- Terminale SSH integrato, con sessioni indipendenti e stato della connessione visibile.
- Tunnel locali (`-L`) e remoti (`-R`) associati a una macchina, attivabili e disattivabili senza modificare la sessione terminale.
- Trasferimenti di file Mac ↔ macchina e macchina ↔ macchina tramite SFTP. Per la prima versione, il trasferimento tra macchine passa attraverso l'app; non richiede che una macchina possa autenticarsi sull'altra.
- Interfaccia SwiftUI/AppKit conforme alle convenzioni macOS: navigazione con tastiera, menu e scorciatoie standard, supporto a modalità chiara/scura, VoiceOver e ridimensionamento.

## Principi

1. Poche viste, azioni esplicite e nessuna configurazione nascosta.
2. Credenziali e passphrase nel Portachiavi; mai nel repository o nei log.
3. Verifica dell'identità dell'host SSH prima della prima connessione e avviso chiaro quando la chiave cambia.
4. Le connessioni e i tunnel si chiudono quando l'utente li interrompe o esce dall'app.
5. App Sandbox come vincolo di progetto, per mantenere possibile la pubblicazione sul Mac App Store.

## Architettura prevista

Il progetto sarà un'app macOS in Swift, aperta e compilata con Xcode. SwiftUI gestirà le viste; AppKit sarà usato dove serve per un terminale con rendering e input adeguati. La gestione SSH, SFTP e dei tunnel resterà dietro interfacce separate dalla UI. La scelta della libreria SSH e del componente terminale richiede una prova tecnica in App Sandbox prima di fissare le dipendenze.

Le configurazioni delle macchine saranno dati locali dell'app. I segreti saranno conservati nel Portachiavi. Per i file locali si useranno i selettori di sistema e, se necessario, bookmark con ambito di sicurezza.

## Distribuzione e aggiornamenti

Il canale principale previsto è il Mac App Store, soggetto a verifica delle funzionalità SSH e dei tunnel nell'App Sandbox e alla revisione Apple. Su quel canale gli aggiornamenti sono distribuiti dal Mac App Store secondo le impostazioni dell'utente. Un eventuale canale diretto, firmato e notarizzato, potrà usare Sparkle per controllare e installare nuove versioni; va tenuto separato dalla build Store.

## Build e CI

GitHub Actions esegue build e test su macOS a ogni pull request e carica un artefatto della build. La creazione di una release distribuibile richiederà identità di firma, certificati e segreti configurati in GitHub; l'artefatto di CI iniziale non equivale a una release firmata o notarizzata.

## Stato

Il progetto Xcode contiene una finestra SwiftUI iniziale e un test. SSH, terminale, tunnel e SFTP non sono ancora implementati. I requisiti e le decisioni aperte sono in [docs/product-context.md](docs/product-context.md).

## Sviluppo locale

Richiede macOS 15 o successivo e Xcode. Aprire `Hop.xcodeproj`, selezionare lo scheme condiviso `Hop` e avviare l'app. Da terminale:

```sh
xcodebuild -project Hop.xcodeproj -scheme Hop -configuration Debug -destination 'platform=macOS' -derivedDataPath /tmp/hop-derived CODE_SIGNING_ALLOWED=NO build
xcodebuild -project Hop.xcodeproj -scheme Hop -configuration Debug -destination 'platform=macOS' -derivedDataPath /tmp/hop-derived CODE_SIGNING_ALLOWED=NO test
```

La CI usa un runner macOS e carica `Hop.app` non firmata per l'ispezione. Questo artefatto non è una release installabile o distribuibile; firma, notarizzazione e validazione App Store restano passaggi separati.

## Licenza

MIT. Vedi [LICENSE](LICENSE).
