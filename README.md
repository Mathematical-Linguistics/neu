# Neu
### The Information-Theoretic Polyglot Language for Living Systems & Bio-P4 Silicon
**Mathematical Linguistics Group (mL-G)** · *Research & Systems Architecture*

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Compiler](https://img.shields.io/badge/Compiler-OCaml%205.x%20%2B%20Menhir-orange.svg)](compiler/)
[![Data-Plane](https://img.shields.io/badge/Data--Plane-P4--16%20%2B%20SMT--LIB2-brightgreen.svg)](runtime/p4/)
[![Treatise](https://img.shields.io/badge/Manuscript-PDF%20(63KB%20Source)-purple.svg)](papers/neu_treatise.pdf)

---

## 🏛️ Executive Vision

Programming languages traditionally enforce syntactic types (e.g. `String -> Int`), while physical systems require **formal safety bounds, data sovereignty, and information-theoretic predictability**. 

**Neu** is a polyglot language engineered by the **Mathematical Linguistics Group (mL-G)** that unites the formal rigor of category theory, the exploratory agility of statistical data science, and the sub-microwatt execution guarantees of programmable biological data planes:

1. **Tri-Substrate Polyglot Synthesis**:
   - **OCaml**: Formal ML kernel, algebraic data types, module functors, and LR(1) grammar verification.
   - **R**: Tabular dataframes and vectorized operations as language primitives with pipe composition (`|>`).
   - **TypeScript / WebAssembly**: Ubiquitous web platform orchestration, async/await ergonomics, and provenance tracking.
   - **Rust**: Opt-in ownership semantics (`own Vec<T>`) for zero-cost performance without garbage-collection pauses.
   - **Haskell**: Purity by default and algebraic effect tracking.

2. **`aie` Information-Theoretic Type System**:
   Functions and pipeline stages are statically checked against Shannon entropy bounds:
   - **Synthesis Engines** ($H(S_n) > H(S_1)$): Generative expansion.
   - **Analysis Engines** ($H(S_n) < H(S_1)$): Dimensionality reduction, feature extraction, and triage.
   - **Transformations** ($H(S_n) = H(S_1)$): Lossless isomorphisms and isometric signal representations.

3. **The Bio-P4 Compilation Bridge (`personal-infra`)**:
   Neu directly bridges high-level clinical contracts with the **Bio-P4 Initiative** ([`personal-infra`](file:///Users/erickoduniyi/Desktop/iig/research/prototypes/personal-infra)):
   - Expresses physiological safety invariants in declarative syntax.
   - Compiles contracts into **Quantifier-Free Bit-Vector (QF_BV) SMT-LIB2 queries** verified by the Z3 theorem prover.
   - Emits verified **P4-16 match-action tables** (`IngressPipe.triage_table`) deployed to sub-100 nW conformable self-powered sensor silicon.

---

## 📐 System Architecture

```
                                  HIGH-LEVEL PROGRAM
                             (contract / vector pipeline)
                                           │
                                           ▼
                            ┌──────────────────────────────┐
                            │      Neu Native Compiler     │
                            │   (OCaml 5.x + Menhir 3.0)   │
                            └──────────────┬───────────────┘
                                           │
                    ┌──────────────────────┴──────────────────────┐
                    ▼                                             ▼
     ┌─────────────────────────────┐               ┌─────────────────────────────┐
     │   aie Entropy Typechecker   │               │       Bio-P4 Synthesizer    │
     │   • Synthesis    (H >)      │               │   • Signal Temporal Logic   │
     │   • Analysis     (H <)      │               │   • Z3 SMT-LIB2 Generation │
     │   • Transformation (H =)    │               │   • P4-16 Match-Action Table│
     └──────────────┬──────────────┘               └──────────────┬──────────────┘
                    │                                             │
                    ▼                                             ▼
     ┌─────────────────────────────┐               ┌─────────────────────────────┐
     │ Vectorized Execution Engine │               │ Programmable Silicon Target │
     │   • R-Style Vector Math     │               │   • Sub-100 nW ASIC Data    │
     │   • Linear Pipelines (|>)   │               │   • 99.9% Baseline Triage   │
     └─────────────────────────────┘               └─────────────────────────────┘
```

---

## ⚡ Quickstart

### Prerequisites
- OCaml $\ge$ 5.0, Dune $\ge$ 3.14, Menhir $\ge$ 3.0 (`opam install dune menhir`)
- Python 3.10+ with `z3-solver` (for SMT execution)

### 1. Build and Run Tests
```bash
cd compiler
dune build
dune runtest
```

### 2. Interactive CLI Demonstration
```bash
dune exec neu -- --demo
```

### 3. Run Vectorized Neu Scripts
```bash
# Evaluates R-style vectorized Fahrenheit-to-Celsius conversion
dune exec neu -- run ../examples/01_vectorized_analytics.neu
```

### 4. Compile Bio-P4 Clinical Safety Contracts
```bash
# Synthesizes Z3 SMT-LIB2 verification assertions and P4-16 table JSON
dune exec neu -- compile --target=p4 ../examples/02_bio_p4_pancreas.neu
```
Outputs:
- `examples/02_bio_p4_pancreas_safety.smt2`
- `examples/02_bio_p4_pancreas_table.json`

---

## 📦 Repository Structure

```
neu/
├── compiler/
│   ├── bin/main.ml             # Neu CLI compiler & evaluator driver
│   ├── lib/
│   │   ├── ast.ml              # AST for expressions, types, contracts & entropy
│   │   ├── eval.ml             # R-style vectorized interpreter & pipeline engine
│   │   ├── lexer.mll           # Lexical tokenizer
│   │   ├── parser.mly          # Menhir LR(1) grammar specification
│   │   ├── p4_codegen.ml       # Bio-P4 SMT-LIB2 & P4-16 table generator
│   │   └── typecheck.ml        # aie Information-theoretic entropy type checker
│   ├── test/test_neu.ml        # Automated test suite
│   └── dune-project            # Dune 3.14 orchestrator
├── examples/
│   ├── 01_vectorized_analytics.neu        # R-style vector arithmetic
│   ├── 02_bio_p4_pancreas.neu             # Artificial pancreas safety contract
│   └── 03_information_theoretic_pipeline.neu # Entropy annotations
├── papers/
│   ├── neu_development.tex     # Comprehensive single-column development paper
│   ├── neu_development.pdf     # Compiled publication-ready PDF
│   └── neu_treatise.tex        # 63KB full academic treatise
├── runtime/
│   ├── p4/                     # Bio-P4 integration assets (bio_synth.ml, bio_synth.py)
│   └── ts/                     # TypeScript orchestration runtime & provenance
└── README.md                   # Project overview & roadmap
```

---

## 🧬 Collaboration & Lineage

Neu is developed under the **Mathematical Linguistics Group (mL-G)** (`https://github.com/Mathematical-Linguistics-Group-mL-G`), continuing the computational lineage of the **MIT Media Lab** and the **Intelligent Interfaces Group (IIG)**:
- **`catling`**: Categorical string diagram reduction engine for DisCoCat pregroup grammars.
- **`disco-station`**: Concurrent spatial acoustic daemon and sheaf consensus router.
- **`neu`**: The high-level information-theoretic language compiling formal categorical and biological contracts into living systems.
