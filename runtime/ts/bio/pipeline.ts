/**
 * Disease Spectroscopy Pipeline
 *
 * Implements the detection pipeline from the participatory design paper:
 * biological sample → spectroscopic measurement → preprocessing → ML classification → clinical output
 *
 * Each stage is classified as an AIE engine type.
 * The pipeline tracks provenance and effects.
 */

import {
  type Result,
  Ok,
  Err,
  pipe,
  dataframe,
  dfFilter,
  dfSelect,
  dfMutate,
  type DataFrame,
  type IO,
  io,
} from "../core/types.js";
import {
  type AnalysisEngine,
  type Transformation,
  type EngineError,
  analysisEngine,
  transformation,
  composeEngines,
} from "../core/engine.js";
import { createProvenanceLog, type ProvenanceLog } from "../cgen/cgen.js";

// ─── Pipeline Types ───

export type DiseaseCategory = "dementia" | "diabetes" | "respiratory";

export interface BiologicalSample {
  readonly id: string;
  readonly contributor: string;
  readonly category: DiseaseCategory;
  readonly sampleType: "blood" | "serum" | "breath" | "csf" | "skin";
  readonly collectedAt: number;
  readonly consentTier: "basic" | "research" | "commercial";
}

export interface SpectralMeasurement {
  readonly sampleId: string;
  readonly method: "ATR-FTIR" | "Mid-IR" | "NIR" | "SERS" | "Fluorescence";
  readonly wavenumbers: number[]; // cm⁻¹
  readonly intensities: number[]; // absorbance units
  readonly measuredAt: number;
}

export interface ProcessedSpectrum {
  readonly sampleId: string;
  readonly features: Map<string, number>;
  readonly baselineCorrected: boolean;
  readonly normalized: boolean;
}

export interface ClassificationResult {
  readonly sampleId: string;
  readonly category: DiseaseCategory;
  readonly riskScore: number; // 0-1
  readonly confidence: number; // 0-1
  readonly keyBiomarkers: string[];
  readonly classifiedAt: number;
}

export interface ClinicalOutput {
  readonly sampleId: string;
  readonly contributor: string;
  readonly result: ClassificationResult;
  readonly provenance: ProvenanceLog;
  readonly attributionChain: string[];
}

// ─── Pipeline Stages as AIE Engines ───

/**
 * Stage 1: Spectroscopic Measurement (Analysis Engine)
 * Reduces a biological sample to spectral data.
 * H(spectral data) < H(biological sample)
 */
export function createMeasurementEngine(
  method: SpectralMeasurement["method"],
): AnalysisEngine<{
  sample: BiologicalSample;
  spectrum?: SpectralMeasurement;
}> {
  return analysisEngine("spectroscopic-measurement", (state) => {
    // Simulate spectral measurement based on disease category
    const wavenumbers = generateWavenumbers(state.sample.category);
    const intensities = wavenumbers.map(
      () => Math.random() * 0.8 + 0.1, // simulated absorbance
    );

    return Ok({
      ...state,
      spectrum: {
        sampleId: state.sample.id,
        method,
        wavenumbers,
        intensities,
        measuredAt: Date.now(),
      },
    });
  });
}

/**
 * Stage 2: Preprocessing (Transformation)
 * Baseline correction, normalization — preserves information content.
 * H(processed) = H(raw spectrum)
 */
export function createPreprocessingEngine(): Transformation<{
  sample: BiologicalSample;
  spectrum?: SpectralMeasurement;
  processed?: ProcessedSpectrum;
}> {
  return transformation("spectral-preprocessing", (state) => {
    if (!state.spectrum) {
      return Err({
        engine: "spectral-preprocessing",
        message: "No spectrum to preprocess",
      });
    }

    const features = new Map<string, number>();
    const { wavenumbers, intensities } = state.spectrum;

    // Extract peak positions and intensities as features
    for (let i = 1; i < wavenumbers.length - 1; i++) {
      if (
        intensities[i] > intensities[i - 1] &&
        intensities[i] > intensities[i + 1]
      ) {
        features.set(`peak_${Math.round(wavenumbers[i])}`, intensities[i]);
      }
    }

    return Ok({
      ...state,
      processed: {
        sampleId: state.spectrum.sampleId,
        features,
        baselineCorrected: true,
        normalized: true,
      },
    });
  });
}

/**
 * Stage 3: Classification (Analysis Engine)
 * Reduces processed spectrum to a risk score.
 * H(risk score) < H(processed spectrum)
 */
export function createClassificationEngine(
  category: DiseaseCategory,
): AnalysisEngine<{
  sample: BiologicalSample;
  spectrum?: SpectralMeasurement;
  processed?: ProcessedSpectrum;
  classification?: ClassificationResult;
}> {
  return analysisEngine("ml-classification", (state) => {
    if (!state.processed) {
      return Err({
        engine: "ml-classification",
        message: "No processed spectrum to classify",
      });
    }

    const biomarkers = getBiomarkers(category);
    const featureCount = state.processed.features.size;

    // Simulated classification
    const riskScore = Math.min(1, featureCount * 0.15 + Math.random() * 0.3);
    const confidence = 0.85 + Math.random() * 0.12; // 85-97% range

    return Ok({
      ...state,
      classification: {
        sampleId: state.sample.id,
        category,
        riskScore,
        confidence,
        keyBiomarkers: biomarkers,
        classifiedAt: Date.now(),
      },
    });
  });
}

// ─── Full Pipeline ───

/**
 * Run the complete detection pipeline for a disease category.
 * Returns a ClinicalOutput with full provenance.
 *
 * Type signature in Neu would be:
 * fn detect(sample: own BiologicalSample) -> Federated<IO<Result<ClinicalOutput, EngineError>>>
 */
export async function runDetectionPipeline(
  sample: BiologicalSample,
): Promise<IO<Result<ClinicalOutput, EngineError>>> {
  const provenance = createProvenanceLog();

  // Log sample contribution
  provenance.append({
    action: "created",
    actor: sample.contributor,
    inputs: [],
    output: sample.id,
    metadata: {
      category: sample.category,
      consentTier: sample.consentTier,
    },
  });

  // Determine method based on disease category
  const method = getMethodForCategory(sample.category);

  // Build the pipeline state
  type PipelineState = {
    sample: BiologicalSample;
    spectrum?: SpectralMeasurement;
    processed?: ProcessedSpectrum;
    classification?: ClassificationResult;
  };

  let state: PipelineState = { sample };

  // Stage 1: Measure
  const measureResult = createMeasurementEngine(method).run(state);
  if (measureResult.kind === "err") return io(measureResult);
  state = measureResult.value as PipelineState;

  provenance.append({
    action: "created",
    actor: "system",
    inputs: [sample.id],
    output: `spectrum-${sample.id}`,
    metadata: { method },
  });

  // Stage 2: Preprocess
  const preprocessResult = createPreprocessingEngine().run(state);
  if (preprocessResult.kind === "err") return io(preprocessResult);
  state = preprocessResult.value as PipelineState;

  provenance.append({
    action: "mutated",
    actor: "system",
    inputs: [`spectrum-${sample.id}`],
    output: `processed-${sample.id}`,
  });

  // Stage 3: Classify
  const classifyResult = createClassificationEngine(sample.category).run(state);
  if (classifyResult.kind === "err") return io(classifyResult);
  state = classifyResult.value as PipelineState;

  provenance.append({
    action: "created",
    actor: "system",
    inputs: [`processed-${sample.id}`],
    output: `classification-${sample.id}`,
    metadata: {
      riskScore: state.classification!.riskScore,
      confidence: state.classification!.confidence,
    },
  });

  // Build attribution chain
  const attributionChain = provenance.records
    .filter((r) => r.actor !== "system")
    .map((r) => r.actor);

  const output: ClinicalOutput = {
    sampleId: sample.id,
    contributor: sample.contributor,
    result: state.classification!,
    provenance,
    attributionChain: [...new Set(attributionChain)],
  };

  return io(Ok(output));
}

// ─── Cohort Analysis with DataFrames ───

/**
 * Analyze a cohort of clinical outputs using R-style data frame operations.
 * This is where Neu's data-first philosophy meets the biomedical pipeline.
 */
export function analyzeCohort(outputs: ClinicalOutput[]) {
  const df = dataframe({
    sampleId: outputs.map((o) => o.sampleId),
    contributor: outputs.map((o) => o.contributor),
    category: outputs.map((o) => o.result.category),
    riskScore: outputs.map((o) => o.result.riskScore),
    confidence: outputs.map((o) => o.result.confidence),
    biomarkerCount: outputs.map((o) => o.result.keyBiomarkers.length),
  });

  // R-style pipeline: filter high-risk, select relevant columns, add derived column
  const highRisk = pipe(df)
    .then((d) => dfFilter(d, (row) => row.riskScore > 0.7))
    .then((d) =>
      dfSelect(d, "sampleId", "contributor", "category", "riskScore"),
    )
    .then((d) =>
      dfMutate(d, {
        riskLevel: (row) =>
          row.riskScore > 0.9 ? ("critical" as const) : ("elevated" as const),
      }),
    )
    .unwrap();

  return { full: df, highRisk };
}

// ─── Helpers ───

function generateWavenumbers(category: DiseaseCategory): number[] {
  const ranges: Record<DiseaseCategory, [number, number]> = {
    dementia: [1600, 1700], // amide I region
    diabetes: [900, 1200], // glucose fingerprint
    respiratory: [1500, 3500], // broad protein/lipid
  };
  const [min, max] = ranges[category];
  const count = 50 + Math.floor(Math.random() * 50);
  return Array.from(
    { length: count },
    (_, i) => min + (i / count) * (max - min),
  );
}

function getMethodForCategory(
  category: DiseaseCategory,
): SpectralMeasurement["method"] {
  const methods: Record<DiseaseCategory, SpectralMeasurement["method"]> = {
    dementia: "ATR-FTIR",
    diabetes: "Mid-IR",
    respiratory: "SERS",
  };
  return methods[category];
}

function getBiomarkers(category: DiseaseCategory): string[] {
  const biomarkers: Record<DiseaseCategory, string[]> = {
    dementia: [
      "Aβ42 β-sheet (1630-1640 cm⁻¹)",
      "phospho-tau",
      "lipid peroxidation",
      "neurofilament light",
    ],
    diabetes: ["glucose (1035 cm⁻¹)", "HbA1c", "triglycerides", "AGEs"],
    respiratory: [
      "exhaled NO",
      "breath acetone",
      "IL-6 cytokine",
      "surfactant lipids",
    ],
  };
  return biomarkers[category];
}
