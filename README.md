# Neu
### A Language for Expressing and Composing Computational Engines
**Mathematical Linguistics Group (mlG)**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Compiler](https://img.shields.io/badge/Compiler-OCaml%205.x%20%2B%20Menhir-orange.svg)](compiler/)
[![Data-Plane](https://img.shields.io/badge/Data--Plane-P4--16%20%2B%20SMT--LIB2-brightgreen.svg)](runtime/p4/)

---

## Overview

Neu is an expressive language designed for defining, communicating, and composing **computational engines**. 

In software systems—whether processing data, analyzing biosignals, or routing audio—computation rarely fits neatly into isolated, static functions. Instead, we work with continuous processes: engines that generate new material, engines that analyze and summarize, and engines that transform data losslessly from one representation into another. 

While the engine concept is grounded in formal mechanisms (such as information-theoretic bounds and categorical pipelines), Neu is built to make expressing them straightforward and applicable. The language synthesizes practical ideas from several languages:

- **From R**: First-class vectorized arithmetic and tabular data. Vector operations work naturally without boilerplate loops, and data flows cleanly through pipe operators (`|>`).
- **From OCaml**: Algebraic data types, pattern matching, fast native compilation, and strong compile-time guarantees.
- **From TypeScript**: Modular orchestration, async workflows, and straightforward integration with web platforms and microfrontends.
- **From Rust**: Clear ownership semantics for performance-critical paths without global garbage-collection surprises.

---

## The Engine Concept

Neu provides a straightforward way to tag and reason about what a computational step is doing:

1. **Synthesis Engines**: Processes that expand or generate information (e.g., sound synthesis, generative design, model expansion).
2. **Analysis Engines**: Processes that compress or extract structure (e.g., sensor triage, feature extraction, diagnostics).
3. **Transformations**: Processes that convert between formats without losing information (e.g., coordinate transforms, rotations, invertible encodings).

```neu
// An analysis engine that compresses high-rate sensor streams
fn on_body_triage(stream): analysis = stream / 4;

// An isometric transform that converts representations losslessly
fn fourier_rotation(sig): transformation = sig + 0;

// An expansive synthesis step
fn expand_spectrum(seed): synthesis = seed * 2;
```

---

## Structural Flow & Topological Operators

Instead of traditional single-tube pipelines, Neu models computation as continuous morphisms using the transformation arrow (`->`) and first-class topological verbs:

- **`split`**: Branching a single flow into concurrent engine paths.
- **`shift`**: Applying temporal, spatial, or phase displacements.
- **`cover`**: Partitioning streams into overlapping open windows / neighborhoods.
- **`cast`**: Functorial re-interpretation into another manifold or protocol frame.
- **`scatter`**: Distributing arrays across spatial channels or hardware lanes.
- **`decompose`**: Unpacking compound signals into constituent bases.

```neu
let wave = [10, 20, 30, 40, 50];

// Shift: temporal or spatial displacement
let delayed = wave -> shift(2);              // [40, 50, 10, 20, 30]

// Cover: overlapping topological windowing (window: 3, step: 1)
let windows = wave -> cover(3, 1);           // [[10, 20, 30], [20, 30, 40], [30, 40, 50]]

// Split: parallel concurrent engine pathways
fn high_pass(x) = x * 2;
fn low_pass(x) = x / 2;
let bands = 100 -> split { high_pass, low_pass }; // [200, 50]

// Cast: functorial reinterpretation
let packet = wave -> cast(BioTelemetry);     // BioTelemetry([10, 20, 30, 40, 50])

// Vectorized arithmetic distributes automatically over arrays
let raw_vitals = [98.6, 99.1, 101.4, 98.4, 102.2];
fn to_celsius(f) = (f - 32.0) * 0.555;
let celsius = raw_vitals -> to_celsius;
```

---

## Quickstart

### Prerequisites
- OCaml $\ge$ 5.0, Dune $\ge$ 3.14, Menhir $\ge$ 3.0 (`opam install dune menhir`)
- Python 3.10+ (optional, for running downstream Z3 verification)

### 1. Build and Test
```bash
cd compiler
dune build
dune runtest
```

### 2. Run the Interactive Demo
```bash
dune exec neu -- --demo
```

### 3. Run a Neu Script
```bash
dune exec neu -- run ../examples/01_vectorized_analytics.neu
```

---

## Repository Structure

```
neu/
├── compiler/
│   ├── bin/main.ml             # CLI driver (run, check, compile)
│   ├── lib/
│   │   ├── ast.ml              # AST for expressions, engines, and contracts
│   │   ├── eval.ml             # Vectorized interpreter and pipe runner
│   │   ├── lexer.mll           # Lexical tokenizer
│   │   ├── parser.mly          # Menhir LR(1) grammar
│   │   ├── p4_codegen.ml       # Hardware target generator (SMT-LIB2 / P4-16)
│   │   └── typecheck.ml        # Engine behavior and entropy checker
│   ├── test/test_neu.ml        # Automated test suite
│   └── dune-project            # Dune project configuration
├── examples/
│   ├── 01_vectorized_analytics.neu            # Vector math and pipes
│   ├── 02_bio_p4_pancreas.neu                 # Closed-loop safety contract
│   └── 03_information_theoretic_pipeline.neu # Engine annotations
├── papers/
│   ├── neu_development.tex     # Development paper source
│   ├── neu_development.pdf     # Compiled single-column report
│   └── neu_treatise.tex        # Reference theoretical paper
├── runtime/
│   ├── p4/                     # Bio-P4 target scripts and solver bridges
│   └── ts/                     # TypeScript runtime modules
└── README.md
```

---

## Applications

While Neu is a general-purpose language for composing engines, it is actively applied across two primary domains:

### 1. Programmable Biological Data Planes (Bio-P4)
In cyber-physical medicine and self-powered wearable sensors (`personal-infra`), controllers cannot rely on unconstrained black-box models. Neu allows safety contracts to be written declaratively and compiled down to hardware match-action tables:

```neu
contract ArtificialPancreasSafety {
  rule 1:   0..70, -50..50 -> suppress_dosage "INV_HYPO_BARRIER";
  rule 2:  71..95, -50..-2 -> set_dosage(5)   "INV_RAMP_SUPPRESS";
  rule 3: 96..130,  -2..5  -> set_dosage(10)  "INV_BASAL_NORM";
  rule 4: 131..180, -2..10 -> set_dosage(25)  "INV_CORRECTION";
  rule 5: 181..400, -2..50 -> set_dosage(40)  "INV_BOLUS_CEILING";
}
```

Running `neu compile --target=p4 <file.neu>` produces:
- A **P4-16 match-action table** (`IngressPipe.triage_table`) deployed to sub-100\,nW silicon, dropping 99.9% of resting baselines on-body.
- A **Quantifier-Free Bit-Vector (QF_BV) SMT-LIB2 formula** verified by the Z3 solver to ensure safety bounds are never breached.

### 2. Living System Instruments & Mathematical Linguistics
Within the Mathematical Linguistics Group (mlG), Neu serves as the high-level language linking categorical grammars (`catling`) with spatial acoustic installations (`disco-station`), allowing formal syntactic structures and audio engines to be expressed within a single pipeline.
