;; =========================================================
;; SMT-LIB2 Safety Verification for Neu Contract: ArtificialPancreasSafety
;; Logic: QF_BV (Quantifier-Free Bit-Vectors)
;; =========================================================
(set-logic QF_BV)

(declare-const G (_ BitVec 16))   ;; Blood Glucose (mg/dL)
(declare-const dG (_ BitVec 16))  ;; Rate of change (mg/dL/min)
(declare-const u (_ BitVec 16))   ;; Delivered dosage (uL/h)

;; Physiological Bounded Domain [40, 400] mg/dL
(assert (bvuge G (_ bv40 16)))
(assert (bvule G (_ bv400 16)))

;; Clinical Invariant: Hypo-barrier at <= 70 mg/dL
(assert (=> (bvule G (_ bv70 16)) (bvult u (_ bv1 16))))

;; Clinical Invariant: Bolus ceiling <= 50 uL/h
(assert (bvule u (_ bv50 16)))

(check-sat)
(get-model)
