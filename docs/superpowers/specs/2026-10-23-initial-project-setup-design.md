# Setup iniziale di Hop

## Intento

Creare una base macOS nativa, apribile in Xcode e verificabile in GitHub Actions, sulla quale sviluppare in seguito SSH, terminale, tunnel e SFTP.

## Ambito

- Progetto `.xcodeproj` versionato, target app SwiftUI e target di unit test.
- Finestra iniziale minimale con nome dell'app e messaggio che indichi lo stato iniziale; nessun controllo che simuli una connessione SSH.
- App Sandbox attiva fin dall'inizio, con entitlement di rete in uscita e in entrata per le future connessioni e i tunnel. Nessun accesso generale al filesystem o a `~/.ssh`.
- Workflow GitHub Actions per pull request: build e test su runner macOS, firma disabilitata, caricamento dell'app compilata come artefatto non distribuibile.
- Istruzioni locali per aprire, compilare e testare il progetto; aggiornamento dello stato nei documenti di prodotto.

## Vincoli e limiti

Per il progetto iniziale propongo macOS 15 come versione minima, SwiftUI senza dipendenze esterne e identificatore bundle `com.mjm.hop` come valore iniziale modificabile prima della distribuzione. SSH, SFTP, Keychain, tunnel e UI definitiva restano fuori da questa fase. Firma, notarizzazione e validazione App Store richiederanno fasi separate.

## Approcci

- **Scelto: `.xcodeproj` versionato.** Si apre direttamente in Xcode e non richiede generatori in locale o in CI. Il file di progetto va mantenuto con attenzione nelle modifiche successive.
- **Alternativa: XcodeGen.** Riduce la manutenzione manuale del progetto ma aggiunge una dipendenza e un passaggio di generazione per ogni checkout e in CI.

## Verifica

`xcodebuild build` e `xcodebuild test` per macOS con firma disabilitata devono riuscire localmente. La configurazione CI deve eseguire gli stessi comandi e caricare il prodotto compilato. La presenza degli entitlement deve essere controllata nel target app.
