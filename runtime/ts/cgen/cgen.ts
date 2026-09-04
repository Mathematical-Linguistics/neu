/**
 * cgen-dlang: Community Generated Design Language
 *
 * Generic evolutionary co-design framework parameterized by domain.
 * This is the OCaml functor pattern in TypeScript:
 * MakeCgen(Domain) → a cgen instance for that domain.
 *
 * The same framework works for visual design, molecular structures,
 * spectroscopic biomarkers, or any domain with components and constraints.
 */

import { Result, Ok, Err, type Option, Some, None } from "../core/types.js";
import {
  type Application,
  type SynthesisEngine,
  type AnalysisEngine,
  type EngineError,
  synthesisEngine,
  analysisEngine,
  application,
} from "../core/engine.js";

// ─── Domain Interface (the "functor parameter") ───

/**
 * A ComponentDomain defines what cgen operates on.
 * Swap this to move from visual design to biomedicine.
 */
export interface ComponentDomain<C, Constraints> {
  /** Validate that a component satisfies the domain grammar */
  validate(component: C, constraints: Constraints): Result<C, string>;

  /** Generate a random component within the grammar */
  random(constraints: Constraints): C;

  /** Mutate a component (evolutionary operator) */
  mutate(component: C, constraints: Constraints): C;

  /** Cross two components (evolutionary operator) */
  cross(a: C, b: C, constraints: Constraints): C;

  /** Compare two components (returns similarity score 0-1) */
  compare(a: C, b: C): number;
}

// ─── Voting Model ───

export interface Vote<C> {
  readonly voter: string;
  readonly component: C;
  readonly score: number; // -1 to 1
  readonly timestamp: number;
}

export interface VotingModel<C> {
  /** Collect votes from the community */
  collectVotes(candidates: C[]): Promise<Vote<C>[]>;

  /** Aggregate votes into a fitness score per candidate */
  aggregate(votes: Vote<C>[]): Map<number, number>;
}

// ─── Provenance (Attribution as Infrastructure) ───

export interface ProvenanceRecord {
  readonly id: string;
  readonly timestamp: number;
  readonly action: "created" | "mutated" | "crossed" | "selected" | "voted";
  readonly actor: string;
  readonly inputs: string[];
  readonly output: string;
  readonly metadata?: Record<string, unknown>;
}

export interface ProvenanceLog {
  readonly records: ProvenanceRecord[];
  append(record: Omit<ProvenanceRecord, "id" | "timestamp">): ProvenanceRecord;
}

export function createProvenanceLog(): ProvenanceLog {
  const records: ProvenanceRecord[] = [];
  return {
    get records() {
      return [...records];
    },
    append(record) {
      const full: ProvenanceRecord = {
        ...record,
        id: `prov-${records.length}-${Date.now()}`,
        timestamp: Date.now(),
      };
      records.push(full);
      return full;
    },
  };
}

// ─── cgen Framework (the "functor") ───

export interface CgenConfig<C, Constraints> {
  readonly name: string;
  readonly domain: ComponentDomain<C, Constraints>;
  readonly constraints: Constraints;
  readonly populationSize: number;
  readonly mutationRate: number;
  readonly votingModel: VotingModel<C>;
}

export interface CgenInstance<C, Constraints> {
  readonly config: CgenConfig<C, Constraints>;
  readonly provenance: ProvenanceLog;

  /** Initialize a random population */
  initialize(): C[];

  /** Run one evolutionary generation with community voting */
  evolve(population: C[]): Promise<Result<C[], EngineError>>;

  /** Get the full provenance chain */
  getProvenance(): ProvenanceRecord[];
}

/**
 * MakeCgen — the functor.
 * Give it a domain and configuration, get back a cgen instance.
 */
export function makeCgen<C, Constraints>(
  config: CgenConfig<C, Constraints>,
): CgenInstance<C, Constraints> {
  const provenance = createProvenanceLog();
  const { domain, constraints, populationSize, mutationRate, votingModel } =
    config;

  return {
    config,
    provenance,

    initialize(): C[] {
      const population: C[] = [];
      for (let i = 0; i < populationSize; i++) {
        const component = domain.random(constraints);
        population.push(component);
        provenance.append({
          action: "created",
          actor: "system",
          inputs: [],
          output: `component-${i}`,
        });
      }
      return population;
    },

    async evolve(population: C[]): Promise<Result<C[], EngineError>> {
      try {
        // 1. Community votes (analysis: reduces population to fitness scores)
        const votes = await votingModel.collectVotes(population);
        const fitness = votingModel.aggregate(votes);

        for (const vote of votes) {
          provenance.append({
            action: "voted",
            actor: vote.voter,
            inputs: [],
            output: `vote-${vote.score}`,
            metadata: { score: vote.score },
          });
        }

        // 2. Selection (analysis: removes less fit candidates)
        const ranked = population
          .map((c, i) => ({ component: c, score: fitness.get(i) ?? 0 }))
          .sort((a, b) => b.score - a.score);

        const survivors = ranked.slice(0, Math.ceil(populationSize / 2));

        for (const s of survivors) {
          provenance.append({
            action: "selected",
            actor: "community",
            inputs: [],
            output: `selected-${s.score}`,
            metadata: { fitnessScore: s.score },
          });
        }

        // 3. Mutation + Crossover (synthesis: generates new candidates)
        const nextGen: C[] = survivors.map((s) => s.component);

        while (nextGen.length < populationSize) {
          const parentA =
            survivors[Math.floor(Math.random() * survivors.length)].component;
          const parentB =
            survivors[Math.floor(Math.random() * survivors.length)].component;

          let child = domain.cross(parentA, parentB, constraints);
          provenance.append({
            action: "crossed",
            actor: "system",
            inputs: ["parentA", "parentB"],
            output: `child-${nextGen.length}`,
          });

          if (Math.random() < mutationRate) {
            child = domain.mutate(child, constraints);
            provenance.append({
              action: "mutated",
              actor: "system",
              inputs: [`child-${nextGen.length}`],
              output: `mutated-child-${nextGen.length}`,
            });
          }

          // Validate against grammar
          const valid = domain.validate(child, constraints);
          if (valid.kind === "ok") {
            nextGen.push(valid.value);
          }
        }

        return Ok(nextGen);
      } catch (cause) {
        return Err({
          engine: "cgen-evolve",
          message: "Evolution cycle failed",
          cause,
        });
      }
    },

    getProvenance(): ProvenanceRecord[] {
      return provenance.records;
    },
  };
}
