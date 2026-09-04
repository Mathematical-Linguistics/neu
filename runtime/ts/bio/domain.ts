/**
 * Biomedical Domain for cgen-dlang
 *
 * Maps cgen's generic framework to personalized medicine:
 * - Components = molecular structures / biomarker signatures
 * - Grammar = biochemical validity constraints
 * - Voting = community governance of research priorities
 * - Evolutionary operators = iterative refinement of drug candidates
 */

import { type Result, Ok, Err } from "../core/types.js";
import type { ComponentDomain } from "../cgen/cgen.js";

// ─── Biomedical Components ───

export interface MolecularStructure {
  readonly id: string;
  readonly name: string;
  readonly type: "drug_candidate" | "biomarker" | "protein_target";
  /** Simplified molecular properties */
  readonly properties: {
    readonly molecularWeight: number; // Daltons
    readonly logP: number; // lipophilicity
    readonly hBondDonors: number;
    readonly hBondAcceptors: number;
    readonly polarSurfaceArea: number; // Å²
    readonly rotatableBonds: number;
  };
  /** Spectroscopic signature (IR wavenumber peaks in cm⁻¹) */
  readonly spectralSignature: number[];
  /** Provenance: who contributed this data */
  readonly contributor?: string;
}

// ─── Biochemical Constraints (the Grammar) ───

export interface BiochemicalGrammar {
  /** Lipinski's Rule of Five for drug-likeness */
  readonly lipinski: {
    readonly maxMolecularWeight: number; // ≤ 500
    readonly maxLogP: number; // ≤ 5
    readonly maxHBondDonors: number; // ≤ 5
    readonly maxHBondAcceptors: number; // ≤ 10
  };
  /** Valid IR wavenumber range for the target disease */
  readonly spectralRange: {
    readonly min: number; // cm⁻¹
    readonly max: number; // cm⁻¹
  };
  /** Maximum polar surface area for oral bioavailability */
  readonly maxPolarSurfaceArea: number; // ≤ 140 Å²
}

// ─── Default Constraints ───

export const DEFAULT_BIOCHEMICAL_GRAMMAR: BiochemicalGrammar = {
  lipinski: {
    maxMolecularWeight: 500,
    maxLogP: 5,
    maxHBondDonors: 5,
    maxHBondAcceptors: 10,
  },
  spectralRange: {
    min: 400, // fingerprint region start
    max: 4000, // mid-IR end
  },
  maxPolarSurfaceArea: 140,
};

// ─── Disease-Specific Constraints ───

export const DEMENTIA_GRAMMAR: BiochemicalGrammar = {
  ...DEFAULT_BIOCHEMICAL_GRAMMAR,
  spectralRange: {
    min: 1600, // amide I region
    max: 1700, // β-sheet to α-helix
  },
};

export const DIABETES_GRAMMAR: BiochemicalGrammar = {
  ...DEFAULT_BIOCHEMICAL_GRAMMAR,
  spectralRange: {
    min: 900, // glucose fingerprint
    max: 1200,
  },
};

export const RESPIRATORY_GRAMMAR: BiochemicalGrammar = {
  ...DEFAULT_BIOCHEMICAL_GRAMMAR,
  spectralRange: {
    min: 1500, // protein/lipid region
    max: 3500, // broad including OH/NH stretches
  },
};

// ─── Biomedical ComponentDomain Implementation ───

export const biomedicalDomain: ComponentDomain<
  MolecularStructure,
  BiochemicalGrammar
> = {
  validate(
    component: MolecularStructure,
    constraints: BiochemicalGrammar,
  ): Result<MolecularStructure, string> {
    const { properties, spectralSignature } = component;
    const { lipinski, spectralRange, maxPolarSurfaceArea } = constraints;

    // Lipinski's Rule of Five
    if (properties.molecularWeight > lipinski.maxMolecularWeight) {
      return Err(
        `Molecular weight ${properties.molecularWeight} exceeds ${lipinski.maxMolecularWeight}`,
      );
    }
    if (properties.logP > lipinski.maxLogP) {
      return Err(`LogP ${properties.logP} exceeds ${lipinski.maxLogP}`);
    }
    if (properties.hBondDonors > lipinski.maxHBondDonors) {
      return Err(
        `H-bond donors ${properties.hBondDonors} exceeds ${lipinski.maxHBondDonors}`,
      );
    }
    if (properties.hBondAcceptors > lipinski.maxHBondAcceptors) {
      return Err(
        `H-bond acceptors ${properties.hBondAcceptors} exceeds ${lipinski.maxHBondAcceptors}`,
      );
    }
    if (properties.polarSurfaceArea > maxPolarSurfaceArea) {
      return Err(
        `Polar surface area ${properties.polarSurfaceArea} exceeds ${maxPolarSurfaceArea}`,
      );
    }

    // Spectral signature must fall within the disease-specific range
    const outOfRange = spectralSignature.filter(
      (peak) => peak < spectralRange.min || peak > spectralRange.max,
    );
    if (outOfRange.length > 0) {
      return Err(
        `Spectral peaks [${outOfRange.join(", ")}] outside range [${spectralRange.min}-${spectralRange.max}] cm⁻¹`,
      );
    }

    return Ok(component);
  },

  random(constraints: BiochemicalGrammar): MolecularStructure {
    const { lipinski, spectralRange } = constraints;
    const numPeaks = 3 + Math.floor(Math.random() * 5);
    const peaks: number[] = [];
    for (let i = 0; i < numPeaks; i++) {
      peaks.push(
        spectralRange.min +
          Math.random() * (spectralRange.max - spectralRange.min),
      );
    }

    return {
      id: `mol-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`,
      name: `candidate-${Math.random().toString(36).slice(2, 6)}`,
      type: "drug_candidate",
      properties: {
        molecularWeight:
          100 + Math.random() * (lipinski.maxMolecularWeight - 100),
        logP: Math.random() * lipinski.maxLogP,
        hBondDonors: Math.floor(Math.random() * (lipinski.maxHBondDonors + 1)),
        hBondAcceptors: Math.floor(
          Math.random() * (lipinski.maxHBondAcceptors + 1),
        ),
        polarSurfaceArea: Math.random() * 140,
        rotatableBonds: Math.floor(Math.random() * 10),
      },
      spectralSignature: peaks.sort((a, b) => a - b),
    };
  },

  mutate(
    component: MolecularStructure,
    constraints: BiochemicalGrammar,
  ): MolecularStructure {
    const { spectralRange } = constraints;
    // Perturb properties slightly
    const perturbFactor = () => 0.9 + Math.random() * 0.2; // ±10%

    // Shift spectral peaks slightly
    const newPeaks = component.spectralSignature.map((peak) => {
      const shifted = peak * perturbFactor();
      return Math.max(spectralRange.min, Math.min(spectralRange.max, shifted));
    });

    return {
      ...component,
      id: `mol-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`,
      name: `${component.name}-mut`,
      properties: {
        ...component.properties,
        molecularWeight: component.properties.molecularWeight * perturbFactor(),
        logP: component.properties.logP * perturbFactor(),
      },
      spectralSignature: newPeaks.sort((a, b) => a - b),
    };
  },

  cross(
    a: MolecularStructure,
    b: MolecularStructure,
    _constraints: BiochemicalGrammar,
  ): MolecularStructure {
    // Crossover: average properties, interleave spectral peaks
    const crossPeaks = [
      ...a.spectralSignature.filter((_, i) => i % 2 === 0),
      ...b.spectralSignature.filter((_, i) => i % 2 === 1),
    ].sort((a, b) => a - b);

    return {
      id: `mol-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`,
      name: `${a.name}×${b.name}`,
      type: "drug_candidate",
      properties: {
        molecularWeight:
          (a.properties.molecularWeight + b.properties.molecularWeight) / 2,
        logP: (a.properties.logP + b.properties.logP) / 2,
        hBondDonors: Math.round(
          (a.properties.hBondDonors + b.properties.hBondDonors) / 2,
        ),
        hBondAcceptors: Math.round(
          (a.properties.hBondAcceptors + b.properties.hBondAcceptors) / 2,
        ),
        polarSurfaceArea:
          (a.properties.polarSurfaceArea + b.properties.polarSurfaceArea) / 2,
        rotatableBonds: Math.round(
          (a.properties.rotatableBonds + b.properties.rotatableBonds) / 2,
        ),
      },
      spectralSignature: crossPeaks,
      contributor: [a.contributor, b.contributor].filter(Boolean).join(" + "),
    };
  },

  compare(a: MolecularStructure, b: MolecularStructure): number {
    // Similarity based on property distance (normalized 0-1)
    const dWeight =
      Math.abs(a.properties.molecularWeight - b.properties.molecularWeight) /
      500;
    const dLogP = Math.abs(a.properties.logP - b.properties.logP) / 5;
    const dPSA =
      Math.abs(a.properties.polarSurfaceArea - b.properties.polarSurfaceArea) /
      140;

    const avgDistance = (dWeight + dLogP + dPSA) / 3;
    return 1 - Math.min(1, avgDistance);
  },
};
