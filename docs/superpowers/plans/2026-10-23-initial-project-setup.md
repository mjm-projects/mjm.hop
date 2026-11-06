# Initial Project Setup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [x]`) syntax for tracking.

**Goal:** Creare l'app macOS Hop minimale, compilabile e testabile localmente e in CI.

**Architecture:** Un `.xcodeproj` versionato contiene i target app e test. La UI SwiftUI mostra solo lo stato iniziale; gli entitlement sandbox sono separati dalla UI. GitHub Actions usa lo scheme condiviso.

**Tech Stack:** Swift, SwiftUI, XCTest o Swift Testing, Xcode, GitHub Actions.

**Spec:** `docs/superpowers/specs/2026-10-23-initial-project-setup-design.md`

## Global Constraints

- macOS 15 minimo; bundle ID iniziale `com.mjm.hop`.
- Nessuna dipendenza esterna, segreto o accesso implicito a `~/.ssh`.
- App Sandbox attiva; entitlement rete in uscita e in entrata.
- CI su macOS per pull request, senza firma, con artefatto compilato.

## Review Focus

- Scheme non condiviso: `xcodebuild -list` da checkout pulito deve trovare Hop.
- Target test escluso dallo scheme: `xcodebuild test` deve eseguire almeno un test reale.
- Entitlement dimenticati nella build: verificare il prodotto con `codesign -d --entitlements` dove disponibile.
- Firma richiesta in CI: i comandi devono usare `CODE_SIGNING_ALLOWED=NO`.
- Artefatto vuoto o nel percorso sbagliato: il workflow deve caricare `Hop.app` da una derived data esplicita.

---

### Task 1: Progetto e app minimale

**Files:**
- Create: `Hop.xcodeproj/project.pbxproj`, `Hop.xcodeproj/xcshareddata/xcschemes/Hop.xcscheme`
- Create: `Hop/HopApp.swift`, `Hop/ContentView.swift`, `Hop/Hop.entitlements`
- Create: `HopTests/HopTests.swift`

**Interfaces:** Il target app espone `ContentView` per il test; lo scheme `Hop` include app e test.

- [x] Creare un test che verifica il testo dello stato iniziale esposto dalla vista, prima dell'implementazione.
- [x] Eseguire il test e osservare il fallimento dovuto al contenuto non ancora presente.
- [x] Implementare la minima vista SwiftUI, il punto d'ingresso e il progetto Xcode con sandbox e scheme condiviso.
- [x] Eseguire `xcodebuild -project Hop.xcodeproj -scheme Hop -configuration Debug -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO test` e confermare il passaggio.
- [x] Eseguire la build separata e ispezionare gli entitlement del target app.

### Task 2: CI e documentazione

**Files:**
- Create: `.github/workflows/ci.yml`
- Modify: `README.md`, `docs/product-context.md`

**Interfaces:** Consuma progetto e scheme `Hop` dal Task 1.

- [x] Aggiungere workflow PR macOS con build, test e upload di `Hop.app` da derived data esplicita.
- [x] Documentare apertura, build, test e limiti dell'artefatto; aggiornare lo stato dei documenti di prodotto.
- [x] Verificare sintassi YAML, percorsi, `xcodebuild build` e `xcodebuild test` localmente.

L’accento di sistema è usato senza un catalogo asset personalizzato, coerentemente con la UI minimale.
