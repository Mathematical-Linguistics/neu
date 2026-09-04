/**
 * AIE Engine System
 *
 * Implements the three engine types from ai expressions:
 * - SynthesisEngine: H(output) > H(input) — adds information
 * - AnalysisEngine:  H(output) < H(input) — removes information
 * - Transformation:  H(output) = H(input) — preserves information
 *
 * In TypeScript we can't enforce entropy constraints at compile time,
 * but we use the type system to classify and compose engines safely.
 */

import { Result, Ok, Err } from "./types.js";

// ─── Engine Classification (AIE Chapter 1) ───

export type EngineKind = "synthesis" | "analysis" | "transformation";

/**
 * Base engine interface.
 * An engine is a process: a sequence of functions applied to a state.
 */
export interface Engine<S> {
  readonly kind: EngineKind;
  readonly name: string;
  run(state: S): Result<S, EngineError>;
}

export interface EngineError {
  readonly engine: string;
  readonly message: string;
  readonly cause?: unknown;
}

/**
 * Synthesis Engine — creates or adds information.
 * E_S : f_1 → ... → f_n ∈ { S_n, S_1 | H(S_n) > H(S_1) }
 */
export interface SynthesisEngine<S> extends Engine<S> {
  readonly kind: "synthesis";
}

/**
 * Analysis Engine — removes or subtracts information.
 * E_A : f_1 → ... → f_n ∈ { S_n, S_1 | H(S_n) < H(S_1) }
 */
export interface AnalysisEngine<S> extends Engine<S> {
  readonly kind: "analysis";
}

/**
 * Transformation — preserves information.
 * T : f_1 → ... → f_n ∈ { S_n, S_1 | H(S_n) = H(S_1) }
 */
export interface Transformation<S> extends Engine<S> {
  readonly kind: "transformation";
}

// ─── Engine Constructors ───

export function synthesisEngine<S>(
  name: string,
  run: (state: S) => Result<S, EngineError>,
): SynthesisEngine<S> {
  return { kind: "synthesis", name, run };
}

export function analysisEngine<S>(
  name: string,
  run: (state: S) => Result<S, EngineError>,
): AnalysisEngine<S> {
  return { kind: "analysis", name, run };
}

export function transformation<S>(
  name: string,
  run: (state: S) => Result<S, EngineError>,
): Transformation<S> {
  return { kind: "transformation", name, run };
}

// ─── Engine Composition (AIE: f_1 → ... → f_n) ───

/**
 * Compose a sequence of engines into a pipeline.
 * Each engine's output feeds into the next.
 * Short-circuits on the first error.
 */
export function composeEngines<S>(...engines: Engine<S>[]): Engine<S> {
  const kind = classifyComposition(engines);
  const name = engines.map((e) => e.name).join(" → ");

  return {
    kind,
    name,
    run(state: S): Result<S, EngineError> {
      let current = state;
      for (const engine of engines) {
        const result = engine.run(current);
        if (result.kind === "err") return result;
        current = result.value;
      }
      return Ok(current);
    },
  };
}

/**
 * Classify a composition of engines.
 * If it contains both synthesis and analysis, it's an application (synthesis).
 * If all are transformations, it's a transformation.
 * Otherwise, it takes the kind of the dominant engine type.
 */
function classifyComposition<S>(engines: Engine<S>[]): EngineKind {
  const hasSynthesis = engines.some((e) => e.kind === "synthesis");
  const hasAnalysis = engines.some((e) => e.kind === "analysis");

  if (hasSynthesis && hasAnalysis) return "synthesis"; // application
  if (hasSynthesis) return "synthesis";
  if (hasAnalysis) return "analysis";
  return "transformation";
}

// ─── Application (AIE Chapter 2) ───

/**
 * An Application uses both synthesis and analysis engines.
 * This is a higher-order construct in AIE.
 */
export interface Application<S> {
  readonly name: string;
  readonly synthesisEngines: SynthesisEngine<S>[];
  readonly analysisEngines: AnalysisEngine<S>[];
  readonly pipeline: Engine<S>;
  run(state: S): Result<S, EngineError>;
}

export function application<S>(config: {
  name: string;
  synthesisEngines: SynthesisEngine<S>[];
  analysisEngines: AnalysisEngine<S>[];
  pipeline: Engine<S>[];
}): Application<S> {
  const composed = composeEngines(...config.pipeline);
  return {
    name: config.name,
    synthesisEngines: config.synthesisEngines,
    analysisEngines: config.analysisEngines,
    pipeline: composed,
    run(state: S) {
      return composed.run(state);
    },
  };
}
