/**
 * Example: AIE + Neu + cgen-dlang for Equitable Biomedicine
 *
 * Demonstrates the full stack:
 * 1. AIE theory → typed engines (synthesis/analysis/transformation)
 * 2. Neu features → pipes, data frames, Result types, effect tracking
 * 3. cgen-dlang → evolutionary co-design with community voting
 * 4. Biomedical domain → disease spectroscopy pipeline with provenance
 */

import { Ok, pipe, dataframe, dfFilter, dfSelect } from "./core/types.js";
import { makeCgen, type Vote } from "./cgen/cgen.js";
import {
  biomedicalDomain,
  DEMENTIA_GRAMMAR,
  type MolecularStructure,
  type BiochemicalGrammar,
} from "./bio/domain.js";
import {
  runDetectionPipeline,
  analyzeCohort,
  type BiologicalSample,
} from "./bio/pipeline.js";

// ═══════════════════════════════════════════════════════
// 1. Set up cgen-dlang for the biomedical domain
// ═══════════════════════════════════════════════════════

// Simulated community voting model
const communityVoting = {
  async collectVotes(
    candidates: MolecularStructure[],
  ): Promise<Vote<MolecularStructure>[]> {
    // In production: real community members vote via the cgen interface
    // Here we simulate a community of 10 voters
    const voters = [
      "patient-advocate-1",
      "patient-advocate-2",
      "community-nurse",
      "tribal-health-liaison",
      "caregiver-1",
      "caregiver-2",
      "researcher-liaison",
      "data-trust-rep",
      "ethics-board-member",
      "community-elder",
    ];

    const votes: Vote<MolecularStructure>[] = [];
    for (const candidate of candidates) {
      for (const voter of voters) {
        votes.push({
          voter,
          component: candidate,
          // Community prefers lower molecular weight (easier to administer)
          // and moderate lipophilicity (good absorption)
          score:
            (1 - candidate.properties.molecularWeight / 500) * 0.5 +
            (candidate.properties.logP > 1 && candidate.properties.logP < 3
              ? 0.5
              : 0),
          timestamp: Date.now(),
        });
      }
    }
    return votes;
  },

  aggregate(votes: Vote<MolecularStructure>[]): Map<number, number> {
    const scores = new Map<number, number>();
    const counts = new Map<number, number>();

    // Group votes by candidate index (simplified)
    for (let i = 0; i < votes.length; i++) {
      const candidateIdx = i % 10; // 10 candidates
      scores.set(
        candidateIdx,
        (scores.get(candidateIdx) ?? 0) + votes[i].score,
      );
      counts.set(candidateIdx, (counts.get(candidateIdx) ?? 0) + 1);
    }

    // Average scores
    for (const [idx, total] of scores) {
      scores.set(idx, total / (counts.get(idx) ?? 1));
    }

    return scores;
  },
};

// ═══════════════════════════════════════════════════════
// 2. Run the evolutionary co-design loop
// ═══════════════════════════════════════════════════════

async function runEvolutionaryDrugDiscovery() {
  console.log("═══ AIE + Neu + cgen-dlang: Equitable Biomedicine ═══\n");

  // Instantiate cgen for the dementia domain
  const dementiaCgen = makeCgen<MolecularStructure, BiochemicalGrammar>({
    name: "dementia-drug-discovery",
    domain: biomedicalDomain,
    constraints: DEMENTIA_GRAMMAR,
    populationSize: 10,
    mutationRate: 0.3,
    votingModel: communityVoting,
  });

  // Initialize population
  let population = dementiaCgen.initialize();
  console.log(`Initial population: ${population.length} candidates`);
  console.log(
    `Constraints: Dementia grammar (spectral range: 1600-1700 cm⁻¹)\n`,
  );

  // Run 3 generations of community-guided evolution
  for (let gen = 1; gen <= 3; gen++) {
    console.log(`── Generation ${gen} ──`);
    const result = await dementiaCgen.evolve(population);

    if (result.kind === "err") {
      console.error(`Evolution failed: ${result.error.message}`);
      return;
    }

    population = result.value;

    // Show top candidate
    const top = population[0];
    console.log(`  Top candidate: ${top.name}`);
    console.log(
      `  MW: ${top.properties.molecularWeight.toFixed(1)}, LogP: ${top.properties.logP.toFixed(2)}`,
    );
    console.log(`  Spectral peaks: ${top.spectralSignature.length} in range`);
    console.log();
  }

  // Show provenance
  const provenance = dementiaCgen.getProvenance();
  console.log(`── Provenance ──`);
  console.log(`Total records: ${provenance.length}`);
  console.log(
    `Community votes: ${provenance.filter((r) => r.action === "voted").length}`,
  );
  console.log(
    `Mutations: ${provenance.filter((r) => r.action === "mutated").length}`,
  );
  console.log(
    `Crossovers: ${provenance.filter((r) => r.action === "crossed").length}`,
  );
  console.log();

  return population;
}

// ═══════════════════════════════════════════════════════
// 3. Run the disease spectroscopy pipeline
// ═══════════════════════════════════════════════════════

async function runSpectroscopyPipeline() {
  console.log("═══ Disease Spectroscopy Pipeline ═══\n");

  // Simulate samples from community contributors
  const samples: BiologicalSample[] = [
    {
      id: "sample-001",
      contributor: "participant-alice",
      category: "dementia",
      sampleType: "blood",
      collectedAt: Date.now(),
      consentTier: "research",
    },
    {
      id: "sample-002",
      contributor: "participant-bob",
      category: "diabetes",
      sampleType: "serum",
      collectedAt: Date.now(),
      consentTier: "commercial",
    },
    {
      id: "sample-003",
      contributor: "participant-carol",
      category: "respiratory",
      sampleType: "breath",
      collectedAt: Date.now(),
      consentTier: "basic",
    },
    {
      id: "sample-004",
      contributor: "participant-david",
      category: "dementia",
      sampleType: "csf",
      collectedAt: Date.now(),
      consentTier: "research",
    },
    {
      id: "sample-005",
      contributor: "participant-elena",
      category: "diabetes",
      sampleType: "skin",
      collectedAt: Date.now(),
      consentTier: "research",
    },
  ];

  // Run pipeline for each sample
  const outputs = [];
  for (const sample of samples) {
    const result = await runDetectionPipeline(sample);

    if (result.kind === "ok") {
      const output = result.value;
      console.log(`Sample ${output.sampleId} (${output.result.category}):`);
      console.log(`  Risk score: ${output.result.riskScore.toFixed(3)}`);
      console.log(
        `  Confidence: ${(output.result.confidence * 100).toFixed(1)}%`,
      );
      console.log(`  Biomarkers: ${output.result.keyBiomarkers.join(", ")}`);
      console.log(`  Attribution: ${output.attributionChain.join(" → ")}`);
      console.log(`  Provenance records: ${output.provenance.records.length}`);
      console.log();
      outputs.push(output);
    }
  }

  // Cohort analysis using R-style data frame operations
  console.log("── Cohort Analysis (R-style DataFrame) ──\n");
  const { full, highRisk } = analyzeCohort(outputs);

  console.log(`Total samples: ${full.length}`);
  console.log(`High-risk samples: ${highRisk.length}`);

  if (highRisk.length > 0) {
    console.log("\nHigh-risk details:");
    for (let i = 0; i < highRisk.length; i++) {
      console.log(
        `  ${highRisk.columns.sampleId[i]} | ${highRisk.columns.contributor[i]} | ${highRisk.columns.category[i]} | risk: ${highRisk.columns.riskScore[i].toFixed(3)} | ${highRisk.columns.riskLevel[i]}`,
      );
    }
  }

  return outputs;
}

// ═══════════════════════════════════════════════════════
// 4. Run everything
// ═══════════════════════════════════════════════════════

async function main() {
  await runEvolutionaryDrugDiscovery();
  console.log("\n" + "─".repeat(60) + "\n");
  await runSpectroscopyPipeline();

  console.log("\n═══ Architecture Summary ═══");
  console.log("AIE (theory)     → engines classify every computation");
  console.log("Neu (language)   → types enforce safety and provenance");
  console.log("cgen-dlang (app) → communities shape the fitness function");
  console.log("Domain           → equitable biomedicine");
  console.log("\nData stays with the person. Attribution is infrastructure.");
  console.log("Compensation flows back. The right to withdraw is absolute.");
}

main().catch(console.error);
