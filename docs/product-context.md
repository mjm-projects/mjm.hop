# Hop — contesto di prodotto e decisioni iniziali

## Scopo

Un posto unico, semplice e nativo su macOS per aprire terminali SSH verso macchine salvate, gestire tunnel di porte e spostare file con SFTP. L'interazione principale è: scegliere una macchina nella lista e aprire il terminale nell'app.

## Flussi essenziali

1. Aggiungere o modificare una macchina con nome, host, porta, utente e riferimento a una credenziale.
2. Aprire una sessione SSH, verificare la chiave dell'host, autenticarsi e usare un terminale interattivo con PTY remoto.
3. Configurare un tunnel locale o remoto: indirizzo e porta di ascolto, host e porta di destinazione, avvio, arresto e stato/errori.
4. Sfogliare i file remoti e trasferirli tra Mac e macchina, o tra due macchine salvate tramite relay SFTP nell'app. Mostrare progresso, annullamento ed errori.

## Prima versione

- Lista macchine e scheda di configurazione.
- Terminale integrato con una o più sessioni, copia/incolla e gestione del ridimensionamento.
- Autenticazione SSH con chiave e password, secondo le capacità della libreria scelta.
- Verifica e persistenza delle chiavi host conosciute all'interno del contenitore dell'app.
- Tunnel TCP locali e remoti. Nessun tunnel dinamico SOCKS nella prima versione.
- Browser file remoto e trasferimenti SFTP con progresso e annullamento.
- Preferenze essenziali e stati di errore comprensibili.

## Scelte architetturali da validare con prototipi

- Libreria SSH/SFTP e widget terminale: devono supportare PTY, forwarding locale/remoto, gestione delle chiavi host, annullamento e licenza compatibile con la distribuzione scelta.
- App Sandbox: testare connessioni in uscita, ascolto locale per tunnel `-L`, connessioni in ingresso richieste dai tunnel `-R` e accesso ai file scelti dall'utente.
- Compatibilità delle funzioni con la revisione del Mac App Store. Nessuna promessa di accettazione prima di una build sandboxed funzionante e dell'esito Apple.
- Versione minima di macOS: 15, fissata nel progetto iniziale. Le architetture supportate saranno validate durante lo sviluppo.

## Dati e sicurezza

- Configurazioni nel contenitore dell'app; segreti in Keychain.
- Chiavi host note nel contenitore dell'app, associate a host e porta. Una chiave cambiata blocca la connessione finché l'utente non prende una decisione esplicita.
- Importazione delle chiavi private tramite selettore di sistema e accesso compatibile con App Sandbox; evitare dipendenze implicite dalla directory `~/.ssh`.
- Trasferimenti da/per il Mac tramite selettore di sistema e accesso limitato ai file autorizzati.
- Nessun invio di telemetria o credenziali a servizi esterni previsto.

## Interfaccia

Finestra principale con barra laterale delle macchine e area di dettaglio che mostra terminale o file. Stato di connessione e tunnel visibile senza occupare spazio eccessivo. Configurazione in un pannello o finestra standard macOS. Menu, navigazione da tastiera, VoiceOver, modalità chiara/scura e testi localizzabili.

## Distribuzione e CI

- Obiettivo: Mac App Store con App Sandbox. Aggiornamenti gestiti dal Mac App Store.
- Possibile distribuzione diretta futura: Developer ID, notarizzazione e Sparkle; build e feed di aggiornamento separati da quelli dello Store.
- GitHub Actions: runner macOS, `xcodebuild build`, `xcodebuild test`, caricamento artefatto. Il workflow è presente con il progetto Xcode e un primo test eseguibile.
- La pubblicazione Store, la firma, la notarizzazione e la pubblicazione di aggiornamenti sono passaggi di release distinti, da configurare quando esistono identità e credenziali di distribuzione.

## Criteri di riuscita

- Una macchina salvata si apre in un terminale funzionante e verifica la chiave host.
- Un tunnel locale e uno remoto si avviano, segnalano errori di porta e si chiudono senza processi residui.
- Un file si trasferisce Mac ↔ macchina e macchina ↔ macchina con progresso e annullamento.
- L'app funziona con App Sandbox attiva e i test passano in CI su macOS.
- La build di distribuzione segue i requisiti del canale scelto; l'approvazione App Store resta soggetta alla revisione Apple.

## Stato del setup iniziale

Il progetto `.xcodeproj` versionato contiene l'app SwiftUI minimale e un target di test. Il bundle ID iniziale è `com.mjm.hop`. L'App Sandbox e gli entitlement di rete in uscita e in entrata sono configurati nel target app; i comportamenti SSH e dei tunnel dovranno comunque essere provati nel sandbox nelle fasi successive.
